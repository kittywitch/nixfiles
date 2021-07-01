{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password
    bitwarden
    wire-desktop
    element-desktop
    exiftool
    thunderbird
    mumble-develop
    dino
    transmission-remote-gtk
    scrcpy
    lm_sensors
    google-chrome
    p7zip
    zip
    unzip
    nyxt
    baresip
    discord
    tdesktop
    yubikey-manager
    vegur
    gparted
    cryptsetup
  ];
}
