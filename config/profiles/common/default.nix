{ config, lib, pkgs, ... }:

let
  sources = import ../../../nix/sources.nix;
  unstable = import sources.nixpkgs-unstable { };
in {
  imports = [
    ../../../modules
    ../../users
    ../desktop
    ../development
    ../gaming
    ../network
    ../sway
    ../yubikey
    (sources.home-manager + "/nixos")
  ];

  #boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  #boot.kernelParams = [ "quiet" ];

  nixpkgs.config = { allowUnfree = true; };

  services.journald.extraConfig = "SystemMaxUse=512M";
  nix.gc.automatic = lib.mkDefault true;
  nix.gc.options = lib.mkDefault "--delete-older-than 1w";
  nix.trustedUsers = [ "root" "@wheel" ];
  environment.variables = {
    EDITOR = "kak";
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };
  
  services.openssh.enable = true;
  services.openssh.ports = lib.mkDefault [ 62954 ];
  services.openssh.passwordAuthentication = false;
  services.openssh.challengeResponseAuthentication = false;
  services.openssh.permitRootLogin = lib.mkDefault "prohibit-password";
  services.openssh.extraConfig = "StreamLocalBindUnlink yes";
  security.sudo.wheelNeedsPassword = lib.mkForce false;

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  environment.systemPackages = with pkgs; [
    smartmontools
    hddtemp
    lm_sensors
    htop
    ripgrep
    git
    kitty.terminfo
    mprime
    wget
    rsync
    pv
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
