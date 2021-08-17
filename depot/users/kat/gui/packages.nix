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
    dino-omemo
    transmission-remote-gtk
    scrcpy
    lm_sensors
    p7zip
    zip
    unzip
    nyxt
    baresip
    discord-nssfix
    tdesktop
    yubikey-manager
    cryptsetup
  ];
}
