{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { };
in {
  imports = [
    ./hardware-configuration.nix
    # db 
    ./services/postgres.nix
    # nginx
    ../../services/nginx.nix
    ./services/virtualHosts.nix
    # services
    ./services/gitea.nix
    ./services/nextcloud.nix
    ./services/bitwarden.nix
    # comms services
    ./services/znc.nix
    ./services/weechat.nix
    ./services/matrix.nix
  ];
  
  meta.deploy.ssh.host = "athame.kittywit.ch";

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking = {
    hostName = "athame";
    domain = "kittywit.ch";
    hostId = "7b0ac74e";
    useDHCP = false;
    interfaces.enp1s0.useDHCP = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "20.09";
}

