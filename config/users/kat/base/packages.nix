{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    tmate
    htop
    fd
    sd
    duc
    bat
    exa-noman
    socat
    rsync
    wget
    ripgrep
    nixpkgs-fmt
    pv
    progress
    zstd
    file
    whois
    dnsutils
    borgbackup
    neofetch
  ];
}
