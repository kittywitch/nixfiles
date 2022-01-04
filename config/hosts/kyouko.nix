{ meta, config, lib, pkgs, ... }:

with lib;

{
  # Imports

  imports = with meta; [
    profiles.hardware.hcloud-imperative
    profiles.network
    users.kat.server
#    users.kat.services.weechat
    services.logrotate
    services.nginx
    services.postgres
    services.restic
    services.taskserver
#    services.znc
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
    resources.kyouko = {
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
      pubkey = "0da9fce0b282c63b449a813183e8fa15d1480b344228068f2af860afafa8928d";
      address = "204:4ac0:63e9:afa7:3897:6caf:d9cf:82e0";
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

