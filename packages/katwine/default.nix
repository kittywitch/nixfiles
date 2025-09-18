{
  lib,
  writeShellScriptBin,
  coreutils,
  wine-tkg-ntsync,
  wine-discord-ipc-bridge,
}: let
  inherit (lib) makeBinPath;
in
  writeShellScriptBin "katwine" ''
    export PATH="$PATH:${lib.makeBinPath [
      coreutils
      wine-tkg-ntsync
    ]}"
    export DISCORDINTEGRATION="${wine-discord-ipc-bridge}";
    exec ${./script.sh} "$@"
  ''
