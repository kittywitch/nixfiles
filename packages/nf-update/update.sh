#!/usr/bin/env bash
set -eu

if [[ -n ${CACHIX_SIGNING_KEY-} ]]; then
	export NF_UPDATE_CACHIX_PUSH=1
fi

cd "$NF_CONFIG_ROOT"

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
nf-actions-test -L

if [[ -n ${NF_UPDATE_CACHIX_PUSH-} ]]; then
	cachix push kittywitch "./${NF_ACTIONS_TEST_OUTLINK}"*/ &
	CACHIX_PUSH=$!
fi

if [[ -z ${NF_UPDATE_GIT_COMMIT-} ]]; then
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
fi

wait ${CACHIX_PUSH-}
