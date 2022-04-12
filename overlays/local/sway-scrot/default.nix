{ wrapShellScriptBin, pkgs }:

wrapShellScriptBin "sway-scrot" ./sway-scrot.sh {
  depsRuntimePath = with pkgs; [ coreutils wl-clipboard slurp grim sway jq libnotify xdotool maim xclip ];
}
