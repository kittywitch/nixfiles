{
  pkgs,
  lib,
  ...
}: {
  home.packages = let
    inherit (lib.meta) getExe;
    ocr = pkgs.writeShellScriptBin "ocr" ''
      set -euo pipefail
      pushd () {
          command pushd "$@" > /dev/null
      }

      popd () {
          command popd "$@" > /dev/null
      }
      args="$(getopt -a -o r: --long rotate: -- "$@")"

      ROTATE=""
      FORMAT="jpg"

      usage(){
        cat <<EOF
      $0 - OCR helper, uses ocrmypdf which uses Tesseract OCR under the hood!
      Usage: $0 <file>
       [ -r input | --rotate input ]: Angle to rotate the image by
       [ -f input | --format input ]: Intermediary format, defaults to jpg
      EOF
        exit 1
      }

      if [ $# -eq 0 ]; then
        usage
        exit 1
      fi

      eval set -- "''${args}"
      while :
      do
        case $1 in
          -r | --rotate) ROTATE="$2" ; shift 2 ;;
          -f | --format) ROTATE="$2" ; shift 2 ;;
          --) shift; break ;;
          *) >&2 echo Unsupported option: $1
            usage ;;
        esac
      done

      INTERMEDIARY="./image.''${FORMAT}"
      pushd $(mktemp -d)
      if [ -n "''${ROTATE}" ]; then
        ${getExe pkgs.imagemagick} $1 -rotate "''${ROTATE}" "''${INTERMEDIARY}"
      else
        ${getExe pkgs.imagemagick} $1 "''${INTERMEDIARY}"
      fi
      ${getExe pkgs.ocrmypdf} -q --rotate-pages-threshold 2.0 --clean --output-type=none \
        --sidecar tmp.txt --rotate-pages --image-dpi 300 --deskew --output-type pdfa --jobs 4 \
        "''${INTERMEDIARY}" - > /dev/null
      printf "%s" "$(< tmp.txt)"
      popd
    '';
  in [
    ocr
  ];
}
