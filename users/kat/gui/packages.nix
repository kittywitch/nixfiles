{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password
    bitwarden
    wire-desktop
    element-desktop
    exiftool
    thunderbird
    mumble-speechd
    dino
    google-chrome
    transmission-remote-gtk
    lm_sensors
    p7zip
    zip
    unzip
    baresip
    discord
    tdesktop
    yubikey-manager
    vegur
    gparted
    cryptsetup
  ];
}
