{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password
    btop
    bitwarden
    lutris
    element-wayland
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
    yubikey-manager
    jmtpfs
    cryptsetup
  ];
}
