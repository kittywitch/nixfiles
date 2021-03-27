{ wrapShellScriptBin, pkgs }:

wrapShellScriptBin "kat-gpg-status" ./kat-gpg-status.sh {
  depsRuntimePath = with pkgs; [ coreutils gnupg ];
}
