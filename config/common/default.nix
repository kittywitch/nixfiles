{ config, lib, pkgs, ... }:

let
  sources = import ../../nix/sources.nix;
in {
  imports = [ ../../modules ../users (sources.home-manager + "/nixos") ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.loader.grub.configurationLimit = 8;
  boot.loader.systemd-boot.configurationLimit = 8;

  nixpkgs.config = { allowUnfree = true; };
  nix = {
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixpkgs-unstable=${sources.nixpkgs-unstable}"
      "nixpkgs-mozilla=${sources.nixpkgs-mozilla}"
      "NUR=${sources.NUR}"
      "arc=${sources.arc-nixexprs}"
    ];
    binaryCaches = [ "https://arc.cachix.org" ];
    binaryCachePublicKeys =
      [ "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=" ];
    gc.automatic = lib.mkDefault true;
    gc.options = lib.mkDefault "--delete-older-than 1w";
    trustedUsers = [ "root" "@wheel" ];
  };

  secrets = {
    root = "/var/lib/kat/secrets";
    persistentRoot = "/var/lib/kat/secrets";
    external = true;
  };

  services.journald.extraConfig = "SystemMaxUse=512M";

  environment.variables = {
    EDITOR = "emacs";
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };

  services.openssh = {
    enable = true;
    ports = lib.mkDefault [ 62954 ];
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
    permitRootLogin = lib.mkDefault "prohibit-password";
    kexAlgorithms = [ "curve25519-sha256@libssh.org" ];
    extraConfig = ''
      StreamLocalBindUnlink yes
      LogLevel VERBOSE 
    '';
  };
  security.sudo.wheelNeedsPassword = lib.mkForce false;

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    smartmontools
    hddtemp
    lm_sensors
    htop
    cachix
    ripgrep
    git
    kitty.terminfo
    nixfmt
    mprime
    wget
    rsync
    pv
    pinentry-curses
    progress
    bc
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
