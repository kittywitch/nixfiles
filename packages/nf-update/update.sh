#!/usr/bin/env bash
set -eu

DISCORD_WEBHOOK_LINK=${DISCORD_WEBHOOK_LINK:-""}

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

send_discord_message "Beginning flake update cron job"

nix flake update "$@"

if [[ -n $(git status --porcelain ./flake.lock) ]]; then
	git -P diff ./flake.lock
else
	echo "no source changes" >&2
	exit
fi

echo "checking that nodes still build..." >&2
if [[ -n ${NF_UPDATE_CACHIX_PUSH-} ]]; then
	export NF_ACTIONS_TEST_OUTLINK=${NF_ACTIONS_TEST_OUTLINK-result}
fi
if [[ -z ${NF_UPDATE_SKIP-} ]]; then
	send_discord_message "checking that nodes still build..."
	if [[ -n ${NF_UPDATE_CACHIX_PUSH-} ]]; then
		export NF_ACTIONS_TEST_OUTLINK=${NF_ACTIONS_TEST_OUTLINK-result}
	fi
  nix run .#nf-actions-test -- -L
fi

if [[ -n ${NF_UPDATE_CACHIX_PUSH-} && -v NF_ACTIONS_TEST_OUTLINK ]]; then
  send_discord_message "Cachix pushing"
	cachix push kittywitch "./${NF_ACTIONS_TEST_OUTLINK}"*/ &
	CACHIX_PUSH=$!
fi

if [[ -z ${NF_UPDATE_GIT_COMMIT-} ]]; then
	wait ${CACHIX_PUSH-}
	exit
fi

if [[ -n $(git diff --staged) ]]; then
	echo "git working tree dirty, refusing to commit..." >&2
	exit 1
fi

git add flake.lock
env \
GIT_{COMMITTER,AUTHOR}_EMAIL=github@kittywit.ch \
	GIT_{COMMITTER,AUTHOR}_NAME="flake cron job" \
git commit --message="chore(ci): flake update"

if [[ ${GITHUB_REF-} = refs/heads/${NF_UPDATE_BRANCH-main} ]]; then
	git push origin HEAD:${NF_UPDATE_BRANCH-main}
  send_discord_message "Pushed a new commit!"
fi

wait ${CACHIX_PUSH-}
