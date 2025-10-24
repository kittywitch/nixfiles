{
  lib,
  writeShellScriptBin,
  imagemagick,
  ocrmypdf,
}:
writeShellScriptBin "ocr" ''
  export PATH="$PATH:${lib.makeBinPath [
    imagemagick
    ocrmypdf
  ]}"
  exec ${./ocr.sh} "$@"
''
