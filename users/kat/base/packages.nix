{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    tmate
    htop
    fd
    sd
    duc
    bat
    exa
    fd
    socat
    rsync
    wget
    ripgrep
    nixfmt
    pv
    progress
    zstd
    file
    whois
    niv
    dnsutils
    rink
    borgbackup
    neofetch
  ];
}
