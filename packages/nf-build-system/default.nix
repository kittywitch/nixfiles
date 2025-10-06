{
  lib,
  writeShellScriptBin,
  git,
  cachix,
  jq,
  lix,
  curl,
}:
writeShellScriptBin "nf-build-system" ''
  export PATH="$PATH:${lib.makeBinPath [
    git
    cachix
    jq
    lix
    curl
  ]}"
  exec ${./build-system.sh} "$@"
''
