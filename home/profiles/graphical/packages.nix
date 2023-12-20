{pkgs, ...}: {
  home.packages = with pkgs; [
    # Password manager
    bitwarden

    # Task managers
    btop
    htop

    # Mail
    thunderbird

    # Music
    spotify

    # Chat
    discord
    nheko # Matrix
    tdesktop # Telegram
    dino # XMPP
    signal-desktop

    # Exocortex
    obsidian

    # Archivery
    unzip
    zip
    p7zip

    # Misc
    gimp-with-plugins # GIMP
    exiftool # EXIF Stripping
    lm_sensors # Sensor Data
    cryptsetup # Encrypted block devices
    yubikey-manager # Yubikey
    yt-dlp # Downloading media
    v4l-utils # Webcam
  ];
}
