#!/usr/bin/env bash
set -euo pipefail

# Configuration
HOMESERVER=${HOMESERVER:-""}
API_ID=${API_ID:-""}
DISCORD_WEBHOOK_LINK=${DISCORD_WEBHOOK_LINK:-""}
TEMPDIR=$(mktemp -d)
MONTHS_TO_KEEP=1

# Helper functions
send_discord_message() {
    local message="$1"
    local escaped_message=$(printf '%s' "$message" | jq -R -s '.')
    curl -s -H "Accept: application/json" -H "Content-Type: application/json" \
         -X POST --data "{\"content\": $escaped_message}" "$DISCORD_WEBHOOK_LINK"
}

get_db_size() {
    sudo -u postgres psql matrix-synapse -t -c \
        "SELECT pg_size_pretty(pg_database_size('matrix-synapse'));" | tr -d ' '
}

get_media_store_size() {
    sudo du /var/lib/matrix-synapse/media_store -hd 0 | awk '{print $1}'
}

get_filesystem_usage() {
    df -h / | awk 'NR==2 {print $5 " (" $3 ")"}' | tr -d '\n'
}

calculate_ratio() {
    local before="$1"
    local after="$2"
    awk "BEGIN {printf \"%.2f\", ($after / $before) * 100}"
}

# Main script
main() {
    # Check for required variables
    if [[ -z "$HOMESERVER" || -z "$API_ID" || -z "$DISCORD_WEBHOOK_LINK" ]]; then
        send_discord_message "Error: HOMESERVER, API_ID, and DISCORD_WEBHOOK_LINK must be set."
        exit 1
    }

    # Initial sizes and usage
    local db_before_size=$(get_db_size)
    local media_before_size=$(get_media_store_size)
    local fs_before_usage=$(get_filesystem_usage)

    send_discord_message "Beginning matrix-synapse optimization process - Database before size: ${db_before_size}, Media store before size: ${media_before_size}, Filesystem usage before: ${fs_before_usage}"

    send_discord_message "Starting synapse"
    systemctl start matrix-synapse
    sleep 5

    send_discord_message "Collecting required room data"
    curl --header "Authorization: Bearer ${API_ID}" \
         "https://${HOMESERVER}/_synapse/admin/v1/rooms?limit=500" > "${TEMPDIR}/roomlist.json"

    jq '.rooms[] | select(.joined_local_members == 0) | .room_id' < "${TEMPDIR}/roomlist.json" > "${TEMPDIR}/to_purge.txt"
    jq -c '.rooms[] | select(.joined_local_members != 0) | .room_id' < "${TEMPDIR}/roomlist.json" > "${TEMPDIR}/history_purge.txt"

    local ts=$(( $(date --date="${MONTHS_TO_KEEP} month ago" +%s)*1000 ))

    send_discord_message "Cleaning up media store"
    curl --header "Authorization: Bearer ${API_ID}" -X POST \
         "https://${HOMESERVER}/_synapse/admin/v1/media/delete?before_ts=${ts}"

    send_discord_message "Deleting empty rooms"
    while read -r room_id; do
        if [ -n "${room_id}" ]; then
            curl --header "Authorization: Bearer ${API_ID}" -X DELETE \
                 -H "Content-Type: application/json" -d "{}" \
                 "https://${HOMESERVER}/_synapse/admin/v2/rooms/${room_id}"
        fi
    done < "${TEMPDIR}/to_purge.txt"

    send_discord_message "Deleting unnecessary room history"
    while read -r room_id; do
        room_id=$(echo "$room_id" | tr -d '"')  # Remove quotes if present
        if [ -n "${room_id}" ]; then
            curl --header "Authorization: Bearer ${API_ID}" -X POST \
                 -H "Content-Type: application/json" \
                 -d "{ \"delete_local_events\": true, \"purge_up_to_ts\": ${ts} }" \
                 "https://${HOMESERVER}/_synapse/admin/v1/purge_history/${room_id}"
        fi
    done < "${TEMPDIR}/history_purge.txt"

    send_discord_message "Performing database optimization"
    systemctl stop matrix-synapse

    send_discord_message "Running synapse_auto_compressor"
    sudo -u matrix-synapse synapse_auto_compressor \
         -p "postgresql://matrix-synapse?user=matrix-synapse&host=/var/run/postgresql/" \
         -c 500 -n 100

    send_discord_message "Reindexing database"
    sudo -u postgres psql matrix-synapse -c "REINDEX (VERBOSE) DATABASE \"matrix-synapse\";"

    send_discord_message "Vacuuming database"
    sudo -u postgres psql matrix-synapse -c "VACUUM FULL VERBOSE;"

    rm -rf "${TEMPDIR}"

    send_discord_message "Synapse cleanup performed, booting up"
    systemctl start matrix-synapse

    # Final sizes, usage, and ratios
    local db_after_size=$(get_db_size)
    local media_after_size=$(get_media_store_size)
    local fs_after_usage=$(get_filesystem_usage)
    local db_ratio=$(calculate_ratio "${db_before_size//[A-Za-z]/}" "${db_after_size//[A-Za-z]/}")
    local media_ratio=$(calculate_ratio "${media_before_size//[A-Za-z]/}" "${media_after_size//[A-Za-z]/}")

    send_discord_message "Matrix-synapse optimization process finished -
Database: ${db_before_size} -> ${db_after_size} (${db_ratio}%),
Media store: ${media_before_size} -> ${media_after_size} (${media_ratio}%),
Filesystem usage: ${fs_before_usage} -> ${fs_after_usage}"
}

# Run the main function
main