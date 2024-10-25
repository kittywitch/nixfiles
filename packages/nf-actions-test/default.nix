{
  wrapShellScriptBin,
  pkgs,
}:
wrapShellScriptBin "nf-actions-test" ./actions-test.sh {
  depsRuntimePath = with pkgs; [
    git
    cachix
    jq
    nix
    curl
  ];
}
