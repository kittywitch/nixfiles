{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    # db 
    ./postgres.nix
    # nginx
    ../../services/nginx.nix
    ./virtualhosts.nix
    # security
    ./fail2ban.nix
    # services
    ./mail.nix
    ./asterisk.nix
    ./gitea.nix
    ./syncplay.nix
    ./nextcloud.nix
    ./bitwarden.nix
    ./taskserver.nix
    # comms
    ./murmur.nix
    ./znc.nix
    ./weechat.nix
    ./matrix.nix
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

