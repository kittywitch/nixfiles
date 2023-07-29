{
  wrapShellScriptBin,
  pkgs,
}:
wrapShellScriptBin "synapse-cleanup" ./cleanup.sh {
  depsRuntimePath = with pkgs; [
    matrix-synapse-tools.rust-synapse-compress-state
    curl
    jq
  ];
}
