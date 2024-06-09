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
    fractal # Matrix
    tdesktop # Telegram
    dino # XMPP
    signal-desktop
    mumble

    # Archivery
    unzip
    zip
    p7zip

    # Misc
    exiftool # EXIF Stripping
    lm_sensors # Sensor Data
    cryptsetup # Encrypted block devices
    yubikey-manager # Yubikey
    v4l-utils # Webcam
  ];
}
