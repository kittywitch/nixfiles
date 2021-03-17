{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    # host-specific services 
    ./postgres.nix
    ./virtualhosts.nix
    ./fail2ban.nix
    # services 
    ../../services/nginx.nix
    ../../services/mail.nix
    ../../services/asterisk.nix
    ../../services/gitea.nix
    ../../services/syncplay.nix
    ../../services/bitwarden.nix
    ../../services/taskserver.nix
    ../../services/murmur.nix
    ../../services/znc.nix
    ../../services/weechat.nix
    ../../services/matrix.nix
  ];

  deploy.profiles = [ "kat" ];
  deploy.ssh.host = "athame.kittywit.ch";

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

  networking.firewall.allowedTCPPorts =
    [ 80 443 5160 5060 8999 64738 1935 53589 ];
  networking.firewall.allowedUDPPorts = [ 5160 5060 64738 ];
  networking.firewall.allowedTCPPortRanges = [{
    from = 10000;
    to = 20000;
  }];
  networking.firewall.allowedUDPPortRanges = [{
    from = 10000;
    to = 20000;
  }];
  system.stateVersion = "20.09";
}

