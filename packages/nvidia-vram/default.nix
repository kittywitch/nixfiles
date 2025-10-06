{
  lib,
  linuxPackages,
  bc,
  writeShellScriptBin,
}:
writeShellScriptBin "nvidia-vram" ''
  export PATH="$PATH:${lib.makeBinPath [
    linuxPackages.nvidia_x11
    bc
  ]}"
  exec ${./nvidia-vram.sh} "$@"
''
