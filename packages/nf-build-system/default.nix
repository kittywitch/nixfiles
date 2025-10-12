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
  export PATH="${lib.makeBinPath [
    git
    cachix
    jq
    lixPackageSets.stable.lix
    curl
  ]}:$PATH"
  exec ${./build-system.sh} "$@"
''
