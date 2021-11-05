{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password
    btop
    bitwarden
    element-wayland
    obsidian
    discord
    exiftool
    thunderbird
    mumble-develop
    dino-omemo
    tdesktop
    transmission-remote-gtk
    scrcpy
    lm_sensors
    p7zip
    zip
    unzip
    nyxt
    baresip
    yubikey-manager
    jmtpfs
    cryptsetup
  ];
}
