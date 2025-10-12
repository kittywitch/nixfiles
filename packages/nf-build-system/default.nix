{
  lib,
  writeShellScriptBin,
  git,
  cachix,
  jq,
  lixPackageSets,
  curl,
}:
writeShellScriptBin "nf-build-system" ''
  export PATH="$PATH:${lib.makeBinPath [
    git
    cachix
    jq
    lixPackageSets.stable.lix
    curl
  ]}"
  exec ${./build-system.sh} "$@"
''
