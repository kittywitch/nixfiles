{pkgs, ...}: {
  home.packages = with pkgs; [
    # task managers
    htop
    btop
    # disk usage
    duc-cli
    # nix formatting
    nixpkgs-fmt
    # show type of files
    file
    # command monitoring
    pv
    # cat but better
    bat
    # sed replacement
    sd
    # sops
    sops
    # find replacement
    fd
    # ripgrep / grep replacement
    ripgrep
    # rename with sed
    rename
    # remote tmux
    tmate
    # remote utilities
    socat
    rsync
    wget
    whois
  ];
}
