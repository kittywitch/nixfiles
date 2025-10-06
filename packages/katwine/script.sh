#!/usr/bin/env bash
set -eoux pipefail

#
# Subsystem configuration
#

system_conf() {
  WINE_CPU_TOPOLOGY=$(nproc --all)
  export WINE_CPU_TOPOLOGY
}

dxvk_conf() {
  export DXVK_CONFIG_FILE="${GAMES_DIR}/dxvk/dxvk.conf"
  export DXVK_USE_PIPECOMPILER=1
}

vkbasalt_conf() {
  export ENABLE_VKBASALT=1
  export VKBASALT_CONFIG_FILE="${GAMES_DIR}/vkbasalt/vkBasalt_FilmicMedium.cfg"
  export VKBASALT_LOG_FILE="${GAMES_DIR}/vkbasalt/vkBasalt_FilmicMedium.log"
  export VKBASALT_LOG_LEVEL="info"
}

caches_conf() {
  export MESA_SHADER_CACHE_DIR="${GAMEDIR}/shader-cache";
  export __GL_SHADER_DISK_CACHE=1
  export __GL_SHADER_DISK_CACHE_PATH="$WINEPREFIX"
}

mangohud_conf() {
  export MANGOHUD=1
  export MANGOHUD_CONFIG="no_display,vsync=1,gl_vsync=0,engine_version,ram,vram,gpu_name,cpu_stats,gpu_stats,frametime,time,wine,winesync,vkbasalt,position=bottom-right,font_size=36"
}

proton_conf() {
  export PROTON_USE_NTSYNC=1
}

proton_setup() {
  system_conf
  mangohud_conf
  proton_conf
  caches_conf
  vkbasalt_conf
  dxvk_conf
}

#
# Runners (Wine, Proton, ...)
#

wine_runner() {
  env TZ="$TZ_IN" LC_ALL="$LC_IN" WINEARCH="$WINEARCH" WINEPREFIX="$WINEPREFIX" wine "$@"
}

proton_runner() {
  # https://www.ibm.com/docs/en/idr/11.4.0?topic=zos-time-zone-codes-tz-environment-variable
  # I don't know why, but for some reason proton uses UTC no matter what. I've tried:
  # * --unset=TZ
  # * changing the TZDIR
  # * not providing any change to TZ or TZDIR
  # The only thing! The only thing that has worked is using something from the link above.
  env TZ="PST8PDT" WINEARCH="$WINEARCH" WINEPREFIX="$WINEPREFIX" STORE="none" PROTONPATH="$PROTONPATH" umu-run "$@"
}

#
# Common executable category abstraction
#

vn() {
  WINEPREFIX="${GAMES_DIR}/VNs"
  cd "$WINEPREFIX"
  LC_IN="ja_JP.UTF-8"
  TZ_IN="Asia/Tokyo"
  wine_runner "./drive_c/cmd.exe" /k "C:/script.bat" "$@"
}

battlenet() {
  WINEPREFIX="${GAMES_DIR}/battlenet"
  GAMEDIR="${WINEPREFIX}/drive_c/Program Files (x86)/Battle.net"
  GAME_EXE="${GAMEDIR}/Battle.net.exe"
  proton_setup
  if [ "$#" -ge 1 ]; then
    case $1 in
        (sc1|s1|sc)
        proton_runner "$GAME_EXE" "--exec=\"launch S1\"" ;;
        (sc2|s2)
        proton_runner "$GAME_EXE" "--exec=\"launch S2\"" ;;
        (wc3|w3)
        # TODO: build and ship a custom patched wine for this... jfc
        export STAGING_SHARED_MEMORY=1
        export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
        proton_runner "$GAME_EXE" "--exec=\"launch W3\"" ;;
    esac
  else
    proton_runner "$GAME_EXE"
  fi
}

#
# Core decision making
#

main() {
  WINEARCH="win64"

  if [ "$#" -ge 1 ]; then
    GAME="$1"
  else
    echo "Please provide at least one parameter";
    exit 1
  fi

  GAMES_DIR="/home/kat/Games";

  # Allow dynamic choice of Proton type to avoid hardcoding
  if [ "$#" -ge 2 ]; then
    PROTONTYPE="${2^^}"
    PROTONVAR="PROTON_${PROTONTYPE}"
    # indirection <3
    PROTONPATH="${!PROTONVAR}"
    DEFAULT_PROTON=0
  else
    # at least have a default, though (sorry users <3)
    DEFAULT_PROTON=1
  fi

  export PROTON_LOG=1

  case "$GAME" in
      (kanon)
      VN_DIR="C:/KEY/KANON_SE_ALL"
      VN_EXE="./REALLIVE.exe"
      VN_ARCH="x86"
      vn "$VN_DIR" "$VN_EXE" "$VN_ARCH" ;;
      (hanahira)
      VN_DIR="C:/hanahira"
      VN_EXE="./HANA9.exe"
      VN_ARCH="x86"
      vn "$VN_DIR" "$VN_EXE" "$VN_ARCH" ;;
      (gw2)
      WINEPREFIX="${GAMES_DIR}/guild-wars-2";
      GAMEDIR="${WINEPREFIX}/drive_c/Program Files/Guild Wars 2"
      GAME_EXE="${GAMEDIR}/Gw2-64.exe"
      export GAMEID="umu-1284210"
      cd "$GAMEDIR"
      if [ $DEFAULT_PROTON -ne 0 ]; then
        PROTONPATH="$PROTON_CACHYOS"
      fi
      proton_setup
      proton_runner "$GAME_EXE" "-autologin" "-windowed" ;;
      (gw|gw1)
      WINEPREFIX="${GAMES_DIR}/guild-wars";
      GAMEDIR="${WINEPREFIX}/drive_c/Program Files/Guild Wars"
      GAME_EXE="${GAMEDIR}/Gw.exe"
      cd "$GAMEDIR"
      if [ $DEFAULT_PROTON -ne 0 ]; then
        # GW1 doesn't work with Proton CachyOS at the moment
        PROTONPATH="$PROTON_GE"
      fi
      proton_setup
      proton_runner "$GAME_EXE" "-lodfull" "-bmp" "-dsound" ;;
      (bnet|battlenet)
      if [ $DEFAULT_PROTON -ne 0 ]; then
        PROTONPATH="$PROTON_GE"
      fi
      battlenet ;;
      (sc1|s1|sc|sc2|s2|wc3|w3)
      if [ $DEFAULT_PROTON -ne 0 ]; then
        PROTONPATH="$PROTON_GE"
      fi
      battlenet "${GAME}" ;;
      (*)
      echo "Unhandled case for \$GAME: \"${GAME}\"" ;;
  esac
}

#
# Entrypoint
#

main "$@"
