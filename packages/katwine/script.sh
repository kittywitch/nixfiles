#!/usr/bin/env bash
set -eoux pipefail
WINEARCH="win64"
GAME="$1"

runner() {
  env TZ="$TZ_JP" LC_ALL="$LC_JP" WINEARCH="$WINEARCH" WINEPREFIX="$WINEPREFIX" wine "$@"
}

vn() {
  WINEPREFIX="/home/kat/Games/VNs"
  cd "$WINEPREFIX"
  LC_JP="ja_JP.UTF-8"
  TZ_JP="Asia/Tokyo"
  runner "./drive_c/cmd.exe" /k "C:/script.bat" "$@"
}

main() {
  if [[ "$GAME" == "kanon" ]]; then
    VN_DIR="C:/KEY/KANON_SE_ALL"
    VN_EXE="./REALLIVE.exe"
    VN_ARCH="x86"
    vn "$VN_DIR" "$VN_EXE" "$VN_ARCH"
  elif [[ "$GAME" == "hanahira" ]]; then
    VN_DIR="C:/hanahira"
    VN_EXE="./HANA9.exe"
    VN_ARCH="x86"
    vn "$VN_DIR" "$VN_EXE" "$VN_ARCH"
  fi
}

main
