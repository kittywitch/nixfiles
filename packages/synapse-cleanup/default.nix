{
  wrapShellScriptBin,
  pkgs,
}:
wrapShellScriptBin "synapse-cleanup" ./cleanup.sh {
  depsRuntimePath = with pkgs; [
    matrix-synapse-tools.rust-synapse-compress-state
    curl
    gawk
    sudo
    postgresql
    rink
    jq
  ];
}
