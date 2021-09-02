{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    smartmontools
    hddtemp
    lm_sensors
    pinentry-curses
    gnupg
    foot.terminfo
  ];
}
