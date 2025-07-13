#!/usr/bin/env bash
set -euo pipefail

DISCORD_WEBHOOK_LINK=${DISCORD_WEBHOOK_LINK:-""}
SYSTEM_LINK=${1:-""}
ALIAS=${2:-""}
SYSTEM_TYPE=${3:-""}

# Helper functions
send_discord_message() {
  local message="$1"
  if [[ -n "$DISCORD_WEBHOOK_LINK" ]]; then
    local escaped_message=$(printf '%s' "$message" | jq -R -s '.')
    curl -s -H "Accept: application/json" -H "Content-Type: application/json" \
      -X POST --data "{\"content\": $escaped_message}" "$DISCORD_WEBHOOK_LINK"
  else
    echo "Discord message (not sent): $message"
  fi
}

init_nfargs() {
  local nflinksuffix="-L"

  nfargs=(
    "${NIX_BUILD_ARGS[@]}"
  )

  if [[ -n "${NF_ACTIONS_TEST_OUTLINK-}" || -n "${NF_UPDATE_CACHIX_PUSH-}" ]]; then
    nfargs+=(
      -o "${NF_ACTIONS_TEST_OUTLINK-result}" "$nflinksuffix"
    )
  else
    nfargs+=(
      --no-link
    )
  fi
}

perform_cachix_push() {
  local nflinksuffix="-L"
  if [[ -n ${NF_UPDATE_CACHIX_PUSH-} ]]; then
    send_discord_message "Cachix pushing ${SYSTEM_TYPE} system build for ${ALIAS}"
    cachix push kittywitch "./${NF_ACTIONS_TEST_OUTLINK-result}$nflinksuffix"*/
  fi
}

perform_garbage_collection() {
  if [[ -n ${NF_ACTIONS_TEST_GC-} ]]; then
    nix-collect-garbage -d
  fi
}

# Main script
if [[ -z "$SYSTEM_LINK" || -z "$ALIAS" || -z "$SYSTEM_TYPE" ]]; then
  echo "Usage: $0 <SYSTEM_LINK> <ALIAS> <SYSTEM_TYPE>" >&2
  exit 1
fi

send_discord_message "Starting ${SYSTEM_TYPE} system build for ${ALIAS}"

if [[ -n ${CACHIX_AUTH_TOKEN-} ]]; then
  export NF_UPDATE_CACHIX_PUSH=1
fi

cd "$NF_CONFIG_ROOT"

if [[ -n ${NF_UPDATE_CACHIX_PUSH-} ]]; then
  export NF_ACTIONS_TEST_OUTLINK=${NF_ACTIONS_TEST_OUTLINK-result}
fi

if [[ ${GITHUB_ACTIONS-} = true && ${RUNNER_NAME-} = "Github Actions"* ]]; then
  echo "Enabled GC between builds due to restricted disk space..." >&2
  export NF_ACTIONS_TEST_GC=1
fi

NIX_BUILD_ARGS=(
  --show-trace
)
NIX_BUILD_ARGS_ASYNC=()

nfsystem=$ALIAS
nfinstallable="${NF_CONFIG_ROOT}#${SYSTEM_LINK}"
init_nfargs

nfwarn=
if [[ -n "${NF_NIX_SYSTEMS_WARN-}" && " ${NF_NIX_SYSTEMS_WARN[*]} " = *" $nfsystem "* ]]; then
  nfwarn=1
fi

if [[ -n ${NF_ACTIONS_TEST_ASYNC-} && -z $nfwarn ]]; then
  NIX_BUILD_ARGS_ASYNC+=("$nfinstallable")
else
  echo "Building ${nfsystem}..." >&2
  echo >&2

  if ! nix build "$nfinstallable" "${nfargs[@]}"; then
    if [[ -n $nfwarn ]]; then
      send_discord_message "Build failure allowed for ${nfsystem}, ignoring..."
      echo "Build failure allowed for ${nfsystem}, ignoring..." >&2
    else
      send_discord_message "Build failure for ${nfsystem}, problem!"
      exit 1
    fi
  else
    send_discord_message "${SYSTEM_TYPE} system build of ${ALIAS} succeeded!"
    perform_cachix_push
    perform_garbage_collection
  fi
fi

if [[ -n ${NF_ACTIONS_TEST_ASYNC-} ]]; then
  init_nfargs
  if nix build "${nfargs[@]}" "${NIX_BUILD_ARGS_ASYNC[@]}"; then
    perform_cachix_push
    perform_garbage_collection
  else
    send_discord_message "Async build failure for ${nfsystem}, problem!"
    exit 1
  fi
fi
