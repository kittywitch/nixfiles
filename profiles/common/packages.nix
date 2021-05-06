{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    smartmontools
    hddtemp
    lm_sensors
    cachix
    pinentry-curses
    kitty.terminfo
    gnupg
  ];
}
