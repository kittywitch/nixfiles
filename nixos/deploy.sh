#!/usr/bin/env bash
set -eu

NF_CONFIG_ROOT=${NF_CONFIG_ROOT-.}

TRUSTED_ARGS=(
	--override-input trusted $NF_CONFIG_ROOT/trusted
	--no-update-lock-file
	--no-write-lock-file
	--quiet
)
if [[ -e trusted/trusted/flake.nix ]]; then
	TRUSTED_ARGS+=(
		--override-input trusted/trusted $NF_CONFIG_ROOT/trusted/trusted
	)
fi

NIXOS_HOST=tewi
NIXOS_TOPLEVEL=network.nodes.nixos.$NIXOS_HOST.system.build.toplevel

if [[ $1 = build ]]; then
	exec nix build --no-link --print-out-paths $NF_CONFIG_ROOT#$NIXOS_TOPLEVEL "${TRUSTED_ARGS[@]}"
elif [[ $1 = switch ]] || [[ $1 = test ]] || [[ $1 = dry-* ]]; then
	METHOD=$1
	shift
	exec nixos-rebuild $METHOD \
		--flake $NF_CONFIG_ROOT#$NIXOS_HOST "${TRUSTED_ARGS[@]}" \
		--no-build-nix \
		--target-host $NIXOS_HOST --use-remote-sudo \
		"$@"
elif [[ $1 = check ]]; then
	DEFAULT=$(nix eval --raw -f $NF_CONFIG_ROOT $NIXOS_TOPLEVEL)
	FLAKE=$(nix eval --raw $NF_CONFIG_ROOT#$NIXOS_TOPLEVEL)
	if [[ $DEFAULT != $FLAKE ]]; then
		echo default.nix: $DEFAULT
		echo flake.nix: $FLAKE
		exit 1
	fi
	echo untrusted ok: $FLAKE

	TRUSTED=$(TRUSTED=1 nix eval --raw -f $NF_CONFIG_ROOT $NIXOS_TOPLEVEL)
	TRUSTED_FLAKE=$(nix eval --raw $NF_CONFIG_ROOT#$NIXOS_TOPLEVEL "${TRUSTED_ARGS[@]}")
	if [[ $TRUSTED != $TRUSTED_FLAKE ]]; then
		echo TRUSTED=1 default.nix: $TRUSTED
		echo trusted/flake.nix: $TRUSTED_FLAKE
		exit 1
	fi
	echo trusted ok: $TRUSTED_FLAKE
else
	echo unknown cmd $1 >&2
	exit 1
fi
