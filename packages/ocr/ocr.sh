#!/usr/bin/env bash

set -euo pipefail
pushd () {
  command pushd "$@" > /dev/null
}

popd () {
  command popd "$@" > /dev/null
}
args="$(getopt -a -o r:f: --long rotate:,format: -- "$@")"

ROTATE=""
FORMAT="jpg"

usage(){
  cat <<EOF
    $0 - OCR helper, uses ocrmypdf which uses Tesseract OCR under the hood!
    Usage: $0 [ARGS] [FILE]
     [ -r input | --rotate input ]: Angle to rotate the image by
     [ -f input | --format input ]: Intermediary format, defaults to jpg
EOF
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

eval set -- "${args}"
while :
do
  case "$1" in
    -r | --rotate) ROTATE="$2" ; shift 2 ;;
    -f | --format) FORMAT="$2" ; shift 2 ;;
    --) shift; break ;;
    *) >&2 echo "Unsupported option: $1"
      usage ;;
  esac
done

INTERMEDIARY="./image.${FORMAT}"
pushd "$(mktemp -d)"
if [ -n "${ROTATE}" ]; then
  magick "$1" -rotate "${ROTATE}" "${INTERMEDIARY}"
else
  magick "$1" "${INTERMEDIARY}"
fi
ocrmypdf -q --clean --output-type=none --sidecar tmp.txt \
  --image-dpi 300 --deskew --output-type pdfa --jobs 4 \
  "${INTERMEDIARY}" - > /dev/null
printf "%s" "$(< tmp.txt)"
popd ""
