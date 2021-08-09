{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password
    bpytop
    bitwarden
    element-desktop
    exiftool
    thunderbird
    mumble-develop
    dino
    transmission-remote-gtk
    scrcpy
    lm_sensors
    p7zip
    zip
    unzip
    nyxt
    baresip
    discord
    tdesktop
    yubikey-manager
    cryptsetup
  ];
}
