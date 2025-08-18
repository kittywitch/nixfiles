{
  lib,
  writeShellScriptBin,
  git,
  cachix,
  jq,
  lix,
  curl,
}: let
  inherit (lib) makeBinPath;
in
  writeShellScriptBin "nf-update" ''
    export PATH="$PATH:${lib.makeBinPath [
      git
      cachix
      jq
      lix
      curl
    ]}"
    exec ${./update.sh} "$@"
  ''
