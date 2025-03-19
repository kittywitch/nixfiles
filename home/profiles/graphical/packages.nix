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
    tdesktop # Telegram
    dino # XMPP
    signal-desktop
    mumble
    keymapp
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
    obsidian
    remmina
    alsa-utils
    pwvucontrol
    veracrypt
    gimp
  ];
}
