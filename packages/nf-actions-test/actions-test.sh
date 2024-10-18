#!/usr/bin/env bash
set -eu

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
	nflinksuffix="$1"
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
			cachix push gensokyo-infrastructure "./${NF_ACTIONS_TEST_OUTLINK-result}$nflinksuffix"*/
			rm -f "./${NF_ACTIONS_TEST_OUTLINK-result}$nflinksuffix"*
		fi
		nix-collect-garbage -d
	fi
}

for nfsystem in "${NF_NIX_SYSTEMS[@]}"; do
	nfinstallable="${NF_CONFIG_ROOT}#nixosConfigurations.${nfsystem}.config.system.build.toplevel"
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
			echo "build failure allowed for ${nfsystem}, ignoring..." >&2
			continue
		fi
		exit $nfbuildexit
	fi

	nfgc
done

if [[ -n ${NF_ACTIONS_TEST_ASYNC-} ]]; then
	init_nfargs ""
	nix build \
		"${nfargs[@]}" \
		"${NIX_BUILD_ARGS_ASYNC[@]}" \
		"$@"

	nfgc
fi
