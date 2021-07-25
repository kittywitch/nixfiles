{ config, users, lib, pkgs, profiles, ... }:

with lib;

{
  imports = [
    ./hw.nix
    # profiles
    users.kat.server
    # host-specific services 
    ./virtualhosts.nix
    # services
    ../../../services/fail2ban.nix
    ../../../services/logrotate.nix
    ../../../services/postgres.nix
    ../../../services/nginx.nix
    ../../../services/mail.nix
    ../../../services/calendar.nix
    ../../../services/xmpp.nix
    ../../../services/gitea
    ../../../services/syncplay.nix
    ../../../services/weechat.nix
    ../../../services/vaultwarden.nix
    ../../../services/taskserver.nix
    ../../../services/murmur.nix
    ../../../services/matrix.nix
    ../../../services/restic.nix
    ../../../services/grafana.nix
    ../../../services/prometheus.nix
    ../../../services/loki.nix
    ../../../services/node-exporter.nix
    ../../../services/promtail.nix
    ../../../services/netdata.nix
    ../../../services/znc.nix
    ../../../services/asterisk.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

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

  kw.fw.public.interfaces = singleton "enp1s0";
  kw.fw.private.interfaces = singleton "yggdrasil";

  kw.fw.public.tcp.ports = singleton 52969;

  deploy.tf.dns.records.kittywitch_athame_v6 = {
    tld = "kittywit.ch.";
    domain = "athame";
    aaaa.address =
      (lib.head config.networking.interfaces.enp1s0.ipv6.addresses).address;
  };

  network.yggdrasil = {
    enable = true;
    pubkey = "55e3f29c252d16e73ac849a6039824f94df1dee670c030b9e29f90584f935575";
    listen.enable = true;
    listen.endpoints = [ "tcp://168.119.126.111:52969" ];
  };
  system.stateVersion = "20.09";
}

