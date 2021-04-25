{ config, pkgs, profiles, ... }:

{
  imports = [
    ./hw.nix
    # profiles
    profiles.kat
    # host-specific services 
    ./postgres.nix
    ./virtualhosts.nix
    ./fail2ban.nix
    # services 
    ../../../services/nginx.nix
    ../../../services/mail.nix
    ../../../services/asterisk.nix
    ../../../services/gitea
    ../../../services/syncplay.nix
    ../../../services/weechat.nix
    ../../../services/bitwarden.nix
    ../../../services/taskserver.nix
    ../../../services/murmur.nix
    ../../../services/znc.nix
    ../../../services/matrix.nix
    ../../../services/restic.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  deploy.target = "infra";

  networking = {
    hostName = "athame";
    domain = "kittywit.ch";
    hostId = "7b0ac74e";
    useDHCP = false;
    interfaces.enp1s0.useDHCP = true;
  };

  networking.firewall.allowedTCPPorts =
    [ 22 80 443 5160 5060 8999 64738 1935 53589 5001 ];
  networking.firewall.allowedUDPPorts = [ 5160 5060 64738 ];
  networking.firewall.allowedTCPPortRanges = [{
    from = 10000;
    to = 20000;
  }];
  networking.firewall.allowedUDPPortRanges = [{
    from = 10000;
    to = 20000;
  }];

   hexchen.network = {
     enable = true;
     pubkey = "55e3f29c252d16e73ac849a6039824f94df1dee670c030b9e29f90584f935575";
     # if server, enable this and set endpoint:
     listen.enable = false;
     listen.endpoints = [
       "tcp://0.0.0.0:0"
     ];
   };
  system.stateVersion = "20.09";
}

