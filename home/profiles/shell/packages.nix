{pkgs, ...}: {
  home.packages = with pkgs; [
    watchexec
    htop
    btop
    gdu
    nixpkgs-fmt
    file
    pv
    sd
    sops
    fd
    ripgrep
    rename
    tmate
    socat
    rsync
    wget
    whois
    jc
    hyperfine
    poop
    nix-search-cli
  ];
}
