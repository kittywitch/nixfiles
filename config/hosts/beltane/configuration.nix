{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { };
in {
  imports = [
    ./hardware-configuration.nix
    ./services/bitwarden.nix
    ./services/znc.nix
    ./services/weechat.nix
    ./services/nginx.nix
    ./services/matrix.nix
    ./services/postgres.nix
  ];
  meta.deploy.ssh.host = "beltane.dork.dev";

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

