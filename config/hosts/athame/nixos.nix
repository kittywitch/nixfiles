{ config, users, lib, pkgs, profiles, services, ... }:

with lib;

{
  # Imports

  imports = [
    profiles.hardware.hcloud-imperative
    users.kat.server
    services.asterisk
    services.fail2ban
    services.filehost
    services.gitea
    services.grafana
    services.logrotate
    services.loki
    services.mail
    services.matrix
    services.murmur
    services.netdata
    services.nginx
    services.node-exporter
    services.postgres
    services.prometheus
    services.promtail
    services.radicale
    services.restic
    services.syncplay
    services.taskserver
    services.vaultwarden
    services.website
    services.weechat
    services.xmpp
    services.znc
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

  kw.fw = {
    public.interfaces = singleton "enp1s0";
    private.interfaces = singleton "yggdrasil";
  };

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

