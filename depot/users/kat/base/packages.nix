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
    niv
    dnsutils
    borgbackup
    neofetch
  ];
}
