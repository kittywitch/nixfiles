{ wrapShellScriptBin, pkgs }:

wrapShellScriptBin "kat-scrot" ./kat-scrot.sh {
  depsRuntimePath = with pkgs; [ coreutils wl-clipboard slurp grim sway jq ];
}
