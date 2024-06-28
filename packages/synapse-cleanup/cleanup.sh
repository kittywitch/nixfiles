#!/usr/bin/env bash
set -euo pipefail

# Provide $HOMESERVER and $API_ID into the program via environment, or uncomment the two below lines:
#read -p "Enter the homeserver name, without https:// prefix: " HOMESERVER
#read -sp "Enter the admin user token required: " API_ID

TEMPDIR=$(mktemp -d)
database_before_size=$(sudo -u postgres psql matrix-synapse -c "SELECT pg_size_pretty(pg_database_size( 'matrix-synapse' ));" | sed -n "3p")
media_store_before_size=$(sudo du /var/lib/matrix-synapse/media_store -hd 0 | awk '{print $1}')
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"Beginning matrix-synapse optimization process - Database before size: ${database_before_size}, Media store before size: ${media_store_before_size}\"}" $DISCORD_WEBHOOK_LINK

echo "Starting synapse, just to make sure it is online for these requests"
systemctl start matrix-synapse
sleep 5

echo "Collecting required room data"
curl --header "Authorization: Bearer ${API_ID}" "https://${HOMESERVER}/_synapse/admin/v1/rooms?limit=500" > "${TEMPDIR}/roomlist.json"
jq '.rooms[] | select(.joined_local_members == 0) | .room_id' < "${TEMPDIR}/roomlist.json" > "${TEMPDIR}/to_purge.txt"
jq '.rooms[] | select(.joined_local_members != 0) | .room_id' < "${TEMPDIR}/roomlist.json" > "${TEMPDIR}/history_purge.txt"
ts=$(( $(date --date="1 month ago" +%s)*1000 ))

echo "Cleaning up media store"
curl --header "Authorization: Bearer ${API_ID}" -X POST "https://${HOMESERVER}/_synapse/admin/v1/media/delete?before_ts=${ts}"
media_store_after_size=$(sudo du /var/lib/matrix-synapse/media_store -hd 0 | awk '{print $1}')

echo "Deleting empty rooms"
rooms_to_remove=$(awk -F '"' '{print $2}' < "${TEMPDIR}/to_purge.txt")
for room_id in $rooms_to_remove; do
    if [ -n "${room_id}" ]; then
        curl --header "Authorization: Bearer ${API_ID}" -X DELETE -H "Content-Type: application/json" -d "{}" "https://${HOMESERVER}/_synapse/admin/v2/rooms/${room_id}"
    fi
done

rooms_to_clean=$(awk -F '"' '{print $2}' < "${TEMPDIR}"/history_purge.txt)
echo "Deleting unnecessary room history"
for room_id in $rooms_to_clean; do
    curl --header "Authorization: Bearer ${API_ID}" -X POST -H "Content-Type: application/json" -d "{ \"delete_local_events\": true, \"purge_up_to_ts\": ${ts} }"  "https://${HOMESERVER}/_synapse/admin/v1/purge_history/${room_id}"
done

echo "Last optimization steps, database optimization, shutting down Synapse"
systemctl stop matrix-synapse

sudo -u matrix-synapse synapse_auto_compressor  -p "postgresql://matrix-synapse?user=matrix-synapse&host=/var/run/postgresql/"  -c 500 -n 100
sudo -u postgres psql matrix-synapse -c "REINDEX (VERBOSE) DATABASE \"matrix-synapse\";"
sudo -u postgres psql matrix-synapse -c "VACUUM FULL VERBOSE;"

rm -rf "${TEMPDIR}"
echo "Synapse cleanup performed, booting up"
systemctl start matrix-synapse
database_after_size=$(sudo -u postgres psql matrix-synapse -c "SELECT pg_size_pretty(pg_database_size( 'matrix-synapse' ));" | sed -n "3p")
curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"Matrix-synapse optimization process finished - Database after size: ${database_after_size}, ratio: ${database_ratio}, Media store after size: ${media_store_after_size}, ratio: ${media_store_ratio}\"}" $DISCORD_WEBHOOK_LINK
