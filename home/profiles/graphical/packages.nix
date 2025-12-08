{pkgs, ...}: {
  home.packages = with pkgs; [
    anki

    # Task managers
    btop
    htop

    aseprite
    # Chat
    telegram-desktop # Telegram
    signal-desktop
    fluffychat
    dino
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
    remmina
    alsa-utils
    pwvucontrol
    veracrypt
    deluge
    gimp
    xarchiver
  ];
}
