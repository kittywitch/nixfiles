{ config, lib, pkgs, profiles, ... }:

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

  networking.interfaces.enp1s0.ipv6.addresses = [{
    address = "2a01:4f8:c2c:b7a8::1";
    prefixLength = 64;
  }];

  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "enp1s0";
  };

  katnet.public.interfaces = singleton "enp1s0";
  katnet.private.interfaces = singleton "hexnet";

  deploy.tf.dns.records.kittywitch_athame_v6 = {
    tld = "kittywit.ch.";
    domain = "athame";
    aaaa.address =
      (lib.head config.networking.interfaces.enp1s0.ipv6.addresses).address;
  };

  hexchen.network = {
    enable = true;
    pubkey = "55e3f29c252d16e73ac849a6039824f94df1dee670c030b9e29f90584f935575";
    # if server, enable this and set endpoint:
    listen.enable = false;
    listen.endpoints =
      [ ];
  };
  system.stateVersion = "20.09";
}

