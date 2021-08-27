{ wrapShellScriptBin, pkgs }:

wrapShellScriptBin "disk-mapper" ./disk-mapper.sh {
  depsRuntimePath = with pkgs; [ coreutils utillinux ];
}
