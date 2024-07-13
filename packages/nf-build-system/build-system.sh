#!/usr/bin/env bash
set -eu

DISCORD_WEBHOOK_LINK=${DISCORD_WEBHOOK_LINK:-""}
SYSTEM_LINK=$1
ALIAS=$2
SYSTEM_TYPE=$3

# Helper functions
send_discord_message() {
    local message="$1"
    local escaped_message=$(printf '%s' "$message" | jq -R -s '.')
    curl -s -H "Accept: application/json" -H "Content-Type: application/json" \
         -X POST --data "{\"content\": $escaped_message}" "$DISCORD_WEBHOOK_LINK"
}

if [[ -n ${CACHIX_SIGNING_KEY-} ]]; then
	export NF_UPDATE_CACHIX_PUSH=1
fi

cd "$NF_CONFIG_ROOT"

if [[ -n ${NF_UPDATE_CACHIX_PUSH-} ]]; then
	export NF_ACTIONS_TEST_OUTLINK=${NF_ACTIONS_TEST_OUTLINK-result}
fi

if [[ ${GITHUB_ACTIONS-} = true && ${RUNNER_NAME-} = "Github Actions"* ]]; then
	# low disk space available on public runners...
	echo "enabled GC between builds due to restricted disk space..." >&2
	export NF_ACTIONS_TEST_GC=1
fi

NIX_BUILD_ARGS=(
	--show-trace
)
NIX_BUILD_ARGS_ASYNC=()

init_nfargs() {
	nflinksuffix="-L"
	shift

	nfargs=(
		"${NIX_BUILD_ARGS[@]}"
	)

	if [[ -n "${NF_ACTIONS_TEST_OUTLINK-}" || -n "${NF_UPDATE_CACHIX_PUSH-}" ]]; then
		nfargs+=(
			-o "${NF_ACTIONS_TEST_OUTLINK-result}$nflinksuffix"
		)
	else
		nfargs+=(
			--no-link
		)
	fi
}

nfgc() {
	if [[ -n ${NF_ACTIONS_TEST_GC-} ]]; then
		if [[ -n ${NF_UPDATE_CACHIX_PUSH-} ]]; then
      send_discord_message "Cachix pushing ${SYSTEM_TYPE} system build for ${ALIAS}"
			cachix push kittywitch "./${NF_ACTIONS_TEST_OUTLINK-result}$nflinksuffix"*/
			rm -f "./${NF_ACTIONS_TEST_OUTLINK-result}$nflinksuffix"*
		fi
		nix-collect-garbage -d
	fi
}

nfinstallable="${NF_CONFIG_ROOT}#${SYSTEM_LINK}"
init_nfargs "-$nfsystem"

nfwarn=
if [[ " ${NF_NIX_SYSTEMS_WARN[*]} " = *" $nfsystem "* ]]; then
  nfwarn=1
fi

if [[ -n ${NF_ACTIONS_TEST_ASYNC-} && -z $nfwarn ]]; then
  NIX_BUILD_ARGS_ASYNC+=("$nfinstallable")
  continue
fi

echo "building ${nfsystem}..." >&2
echo >&2

nfbuildexit=0
nix build "$nfinstallable" \
  "${nfargs[@]}" \
  "$@" || nfbuildexit=$?

if [[ $nfbuildexit -ne 0 ]]; then
  if [[ -n $nfwarn ]]; then
    send_discord_message "build failure allowed for ${nfsystem}, ignoring..."
    echo "build failure allowed for ${nfsystem}, ignoring..." >&2
    continue
  fi
  send_discord_message "build failure for ${nfsystem}, problem!"
  exit $nfbuildexit
fi

send_discord_message "${SYSTEM_TYPE} system build of ${ALIAS} succeeded!"

nfgc

if [[ -n ${NF_ACTIONS_TEST_ASYNC-} ]]; then
	init_nfargs ""
	nix build \
		"${nfargs[@]}" \
		"${NIX_BUILD_ARGS_ASYNC[@]}" \
		"$@"

	nfgc
fi