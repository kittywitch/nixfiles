{ config, lib, pkgs, ... }:

let
  home-manager = fetchGit {
    url = "https://github.com/nix-community/home-manager";
    rev = "a98ec6ec158686387d66654ea96153ec06be33d7";
  };
in {
  imports = [ ../../../modules "${home-manager}/nixos" ./pbb.nix ./users.nix ];

  nixpkgs.overlays =
    [ (self: super: import ../../../pkgs { nixpkgs = super.path; }) ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  #boot.kernelParams = [ "quiet" ];

  nixpkgs.config = { allowUnfree = true; };

  services.journald.extraConfig = "SystemMaxUse=512M";
  nix.gc.automatic = lib.mkDefault true;
  nix.gc.options = lib.mkDefault "--delete-older-than 1w";
  nix.trustedUsers = [ "root" "@wheel" ];
  environment.variables.EDITOR = "neovim";

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
    lm_sensors
    htop
    neovim
    ripgrep
    git
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
