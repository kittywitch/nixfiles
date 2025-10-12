{
  lib,
  writeShellScriptBin,
  git,
  cachix,
  jq,
  lixPackageSets,
  curl,
}:
writeShellScriptBin "nf-update" ''
  export PATH="$PATH:${lib.makeBinPath [
    git
    cachix
    jq
    lixPackageSets.stable.lix
    curl
  ]}"
  exec ${./update.sh} "$@"
''
