{
  lib,
  writeShellScriptBin,
  git,
  cachix,
  jq,
  nix,
  curl,
}: let
  inherit (lib) makeBinPath;
in
  writeShellScriptBin "nf-build-system" ''
    export PATH="$PATH:${lib.makeBinPath [
      git
      cachix
      jq
      nix
      curl
    ]}"
    exec ${./build-system.sh} "$@"
  ''
