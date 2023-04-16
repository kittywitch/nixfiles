{pkgs, ...}: {
  home.packages = with pkgs; [
    # Password manager
    bitwarden
    # Task managers
    btop
    htop
    # Browser
    brave
    # Mail
    thunderbird
    # Music
    spotify
    playerctl
    # Chat
    discord
    nheko # Matrix
    tdesktop # Telegram
    dino # XMPP
    signal-desktop
    mumble-develop
    # IDEs
    jetbrains.idea-community
    jetbrains.pycharm-community
    # Exocortex
    obsidian
    # Archivery
    unzip
    zip
    p7zip
    # Misc
    exiftool # EXIF Stripping
    lm_sensors # Sensor Data
    cryptsetup # Encrypted block devices
    yubikey-manager # Yubikey
  ];
}
