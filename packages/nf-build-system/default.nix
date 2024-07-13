{
  wrapShellScriptBin,
  pkgs,
}:
wrapShellScriptBin "nf-build-system" ./build-system.sh {
  depsRuntimePath = with pkgs; [
    git
    cachix
    jq
    nix
    curl
  ];
}
