#!/usr/bin/env bash
HOST=$(hostname -s)
nix eval --argstr hostname "$HOST" -f expr.nix --json expr > ./stylix.json
