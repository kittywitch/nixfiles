{ config, users, lib, pkgs, profiles, ... }:

with lib;

{
  # Imports

  imports = [
    # profiles
    profiles.hardware.hcloud-imperative
    users.kat.server
    # host-specific services 
    ./nixos/virtualhosts.nix
    # services
    ../../services/fail2ban.nix
    ../../services/logrotate.nix
    ../../services/postgres.nix
    ../../services/nginx.nix
    ../../services/mail.nix
    ../../services/radicale.nix
    ../../services/xmpp.nix
    ../../services/gitea
    ../../services/syncplay.nix
    ../../services/weechat.nix
    ../../services/vaultwarden.nix
    ../../services/taskserver.nix
    ../../services/murmur.nix
    ../../services/matrix.nix
    ../../services/restic.nix
    ../../services/grafana.nix
    ../../services/prometheus.nix
    ../../services/loki.nix
    ../../services/node-exporter.nix
    ../../services/promtail.nix
    ../../services/netdata.nix
    ../../services/znc.nix
    ../../services/asterisk.nix
  ];

  # File Systems and Swap

  fileSystems = {
    "/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
  };

  # Bootloader

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };


  # Networking

  networking = {
    hostName = "athame";
    domain = "kittywit.ch";
    hostId = "7b0ac74e";
    useDHCP = false;
    interfaces = {
      enp1s0 = {
        useDHCP = true;
        ipv6.addresses = [{
          address = "2a01:4f8:c2c:b7a8::1";
          prefixLength = 64;
        }];
      };
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };

  # Firewall

  kw.fw.public.interfaces = singleton "enp1s0";
  kw.fw.private.interfaces = singleton "yggdrasil";

  # Host-specific DNS Config

  kw.dns.ipv4 = "168.119.126.111";
  kw.dns.ipv6 = (lib.head config.networking.interfaces.enp1s0.ipv6.addresses).address;

  deploy.tf.dns.records.kittywitch_athame_v6 = {
    tld = "kittywit.ch.";
    domain = "athame";
    aaaa.address = config.kw.dns.ipv6;
  };

  # Yggdrasil

  network.yggdrasil = {
    enable = true;
    pubkey = "55e3f29c252d16e73ac849a6039824f94df1dee670c030b9e29f90584f935575";
    listen.enable = true;
    listen.endpoints = [ "tcp://${config.kw.dns.ipv4}:52969" ];
  };

  # State
  system.stateVersion = "20.09";
}

