{
  lib,
  writeShellScriptBin,
  git,
  cachix,
  jq,
  lix,
  curl,
}:
writeShellScriptBin "nf-update" ''
  export PATH="$PATH:${lib.makeBinPath [
    git
    cachix
    jq
    lix
    curl
  ]}"
  exec ${./update.sh} "$@"
''
