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
  writeShellScriptBin "nf-update" ''
    export PATH="$PATH:${lib.makeBinPath [
      git
      cachix
      jq
      nix
      curl
    ]}"
    exec ${./update.sh} "$@"
  ''
