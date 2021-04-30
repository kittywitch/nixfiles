{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    smartmontools
    hddtemp
    lm_sensors
    htop
    cachix
    borgbackup
    ripgrep
    git
    nixfmt
    wget
    rsync
    pv
    pinentry-curses
    kitty.terminfo
    progress
    bc
    bat
    zstd
    file
    whois
    fd
    exa
    socat
    tmux
    gnupg
  ];
}
