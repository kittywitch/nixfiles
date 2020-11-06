{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { };
in {
  imports = [
    ../../profiles/common
    ./hardware-configuration.nix
    #./services/postgres.nix
    ./services/znc.nix
    ./services/weechat.nix
    #./services/gitea.nix
    #./services/matrix.nix
    #./services/nextcloud.nix
    #./services/bitwarden.nix
    ./services/nginx.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking = {
    hostName = "beltane";
    useDHCP = false;
    interfaces.enp1s0.useDHCP = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "20.09";
}

