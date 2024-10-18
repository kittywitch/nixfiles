{
  wrapShellScriptBin,
  pkgs,
}:
wrapShellScriptBin "nf-update" ./update.sh {
  depsRuntimePath = with pkgs; [
    git
    cachix
    jq
    curl
    nf-actions-test
  ];
}
