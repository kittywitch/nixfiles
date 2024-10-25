#!/usr/bin/env bash
set -eu

for ciconfig in "${NF_CONFIG_FILES[@]}"; do
	echo "processing ${ciconfig}..." >&2
	nix run --argstr config "$NF_CONFIG_ROOT/ci/$ciconfig" -f "$NF_INPUT_CI" run.gh-actions-generate
done
