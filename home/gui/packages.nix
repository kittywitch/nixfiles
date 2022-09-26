{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    bitwarden
    discord
    exiftool
    thunderbird
    mumble-develop
    dino
    tdesktop
    headsetcontrol
    transmission-remote-gtk
    lm_sensors
    p7zip
    zip
    unzip
    yubikey-manager
    jmtpfs
    element-desktop
    cryptsetup
    esphome
  ];
}
