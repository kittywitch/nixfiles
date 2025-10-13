#!/usr/bin/env bash
set -eu

CI_NOTIFY_LINK="${CI_NOTIFY_LINK:-""}"
CI_NOTIFY_TOKEN="${CI_NOTIFY_TOKEN:-""}"

# Helper functions
send_notification() {
  local priority="$1"
  local tag="$2"
  local message="$3"
  curl -s -X POST \
    -H "Authorization: Bearer ${CI_NOTIFY_TOKEN}" \
    -H "prio:${priority}" \
    -H "tags:${tag}" \
    -d "$message" \
    "${CI_NOTIFY_LINK}"
}

if [[ -n ${CACHIX_AUTH_TOKEN-} ]]; then
  export NF_UPDATE_CACHIX_PUSH=1
fi

cd "$NF_CONFIG_ROOT"

send_notification "low" "gear" "Beginning flake update cron job"

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
  send_notification "low" "information_source" "Checking that nodes still build..."
  if [[ -n ${NF_UPDATE_CACHIX_PUSH-} ]]; then
    export NF_ACTIONS_TEST_OUTLINK=${NF_ACTIONS_TEST_OUTLINK-result}
  fi
  nix run .#nf-actions-test -- -L
fi

if [[ -n ${NF_UPDATE_CACHIX_PUSH-} && -v NF_ACTIONS_TEST_OUTLINK ]]; then
  send_notification "low" "floppy_disk" "Cachix pushing"
  cachix push kittywitch "./${NF_ACTIONS_TEST_OUTLINK}"*/ &
  CACHIX_PUSH=$!
fi

if [[ -z ${NF_UPDATE_GIT_COMMIT-} ]]; then
  wait "${CACHIX_PUSH-}"
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
  git push origin "HEAD:${NF_UPDATE_BRANCH-main}"
  send_notification "low" "white_check_mark" "Pushed a new commit!"
fi

wait "${CACHIX_PUSH-}"
