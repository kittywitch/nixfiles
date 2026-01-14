{
  pkgs,
  lib,
  std,
  ...
}: let
  inherit (lib.attrsets) genAttrs;
  inherit (std) set;
in {
  xdg.mimeApps = {
    enable = true;
    # https://www.iana.org/assignments/media-types/media-types.xhtml
    defaultApplications = let
    genDefault = application: types: genAttrs types (_: application);
    mimePrefix = prefix: map (x: "${prefix}/${x}");
    archiveTypes = mimePrefix "application" [
      "x-bzip"
      "x-bzip2"
      "gzip"
      "x-gzip"
      "x-zip"
      "x-tar"
      "x-7z-compressed"
    ];
    imageTypes = mimePrefix "image" [
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
    videoTypes = mimePrefix "video" [
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
    archiveDefaults = genDefault "ark.desktop" archiveTypes;
    imageDefaults = genDefault "imv.desktop" imageTypes;
    videoDefaults = genDefault "mpv.desktop" videoTypes;
    combinedDefaults = set.merge [
        archiveDefaults
        imageDefaults
        videoDefaults
        {
          "inode/directory" = "dolphin.desktop";
        }
    ];
  in
    combinedDefaults;
  };
  home.packages = with pkgs; [
    anki

    # File management
    kdePackages.dolphin

    # Imagery
    aseprite
    imv
    gimp
    blender
    krita

    # Chat
    telegram-desktop # Telegram
    signal-desktop
    fluffychat
    dino
    mumble

    # Archivery
    kdePackages.ark
    unzip
    zip
    p7zip
    rar

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
