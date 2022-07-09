{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neofetch
    smartmontools
    hddtemp
    lm_sensors
    gnupg
  ] ++ (lib.optional config.programs.gnupg.agent.enable pinentry-curses);
}
