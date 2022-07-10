{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # disk usage 
    duc-cli
    # nix formatting
    nixpkgs-fmt
    # show type of files
    file
    # command monitoring
    progress
    pv
    # cat but better
    bat
    # ls replacement
    exa
    # sed replacement
    sd
    # find replacement
    fd
    # ripgrep / grep replacement
    ripgrep
    # remote tmux
    tmate
    # remote utilities
    socat
    rsync
    wget
    dnsutils
    whois
  ];
}
