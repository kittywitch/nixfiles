{
  lib,
  linuxPackages,
  bc,
  writeShellScriptBin,
}: let
  inherit (lib) makeBinPath;
in
  writeShellScriptBin "nvidia-vram" ''
    export PATH="$PATH:${lib.makeBinPath [
      linuxPackages.nvidia_x11
      bc
    ]}"
    exec ${./nvidia-vram.sh} "$@"
  ''
