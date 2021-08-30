{ meta, config, lib, pkgs, ... }:

with lib;

{
  # Imports

  imports = with meta; [
    profiles.hardware.hcloud-imperative
    users.kat.server
    users.kat.services.weechat
    services.filehost
    services.gitea
    services.logrotate
    services.mail
    services.matrix
    services.murmur
    services.nginx
    services.postgres
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

  kw.monitoring = {
    server.enable = true;
  };

  services.prometheus = {
    scrapeConfigs = [
      {
        job_name = "boline";
        static_configs = [{ targets = [ "boline.${config.network.addresses.yggdrasil.prefix}.${config.network.dns.domain}:8002" ]; }];
      }
    ];
  };

  # Terraform

  deploy.tf = {
    resources.athame = {
      provider = "null";
      type = "resource";
      connection = {
        port = head config.services.openssh.ports;
        host = config.network.addresses.public.nixos.ipv4.address;
      };
    };
  };

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
          address = config.network.addresses.public.nixos.ipv6.address;
          prefixLength = 64;
        }];
      };
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };

  network = {
    addresses = {
      public = {
        enable = true;
        nixos = {
          ipv4.address = "168.119.126.111";
          ipv6.address = "2a01:4f8:c2c:b7a8::1";
        };
      };
    };
    yggdrasil = {
      enable = true;
      pubkey = "55e3f29c252d16e73ac849a6039824f94df1dee670c030b9e29f90584f935575";
      listen.enable = true;
      listen.endpoints = [ "tcp://${config.network.addresses.public.nixos.ipv4.address}:52969" "tcp://[${config.network.addresses.public.nixos.ipv6.address}]:52969" ];
    };
  };

  # Firewall

  network.firewall = {
    public = {
      interfaces = singleton "enp1s0";
      tcp.ports = singleton 52969;
    };
    private.interfaces = singleton "yggdrasil";
  };

  # State
  system.stateVersion = "20.09";
}

