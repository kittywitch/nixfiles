{
  lib,
  writeShellScriptBin,
  coreutils,
  wine-discord-ipc-bridge,
  umu-launcher,
  mangohud,
  vkbasalt,
  wine-tkg,
}:
writeShellScriptBin "katwine" ''
  export PATH="$PATH:${lib.makeBinPath [
    coreutils
    umu-launcher
    mangohud
    vkbasalt
    wine-tkg
  ]}"
  export DISCORDINTEGRATION="${wine-discord-ipc-bridge}";
  source ${./script.sh}
''
