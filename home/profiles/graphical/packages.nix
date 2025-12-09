{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.attrsets) genAttrs;
in {
  xdg.mimeApps.defaultApplications = let
    genDefault = application: types: genAttrs types (_: application);
    imageTypes = map (x: "image/${x}") [
      "apng"
      "avif"
      "bmp"
      "gif"
      "heic"
      "heif"
      "jpeg"
      "png"
      "svg+xml"
      "webp"
    ];
    videoTypes = map (x: "video/${x}") [
      "AV1"
      "H264"
      "H265"
      "matroska"
      "mp4"
      "MPV"
      "mpeg"
      "ogg"
      "VP8"
      "VP9"
    ];
    imageDefaults = genDefault "imv.desktop" imageTypes;
    videoDefaults = genDefault "mpv.desktop" videoTypes;
    combinedDefaults = imageDefaults // videoDefaults;
  in
    combinedDefaults;
  home.packages = with pkgs; [
    anki

    # Imagery
    aseprite
    imv
    gimp

    # Chat
    telegram-desktop # Telegram
    signal-desktop
    fluffychat
    dino
    mumble

    # Archivery
    xarchiver
    unzip
    zip
    p7zip

    # Misc
    exiftool # EXIF Stripping
    lm_sensors # Sensor Data
    cryptsetup # Encrypted block devices
    yubikey-manager # Yubikey
    v4l-utils # Webcam
    remmina
    alsa-utils
    pwvucontrol
    veracrypt
    deluge
  ];
}
