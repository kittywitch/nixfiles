{ meta, tf, config, pkgs, lib, ... }:

with lib;

{
  # Imports

  imports = with meta; [
    profiles.hardware.rm-310
    profiles.gui
    users.kat.guiFull
    services.jellyfin
    services.kattv-ingest
    services.promtail
    services.netdata
    services.nfs
    services.nginx
    services.node-exporter
    services.transmission
    services.tvheadend
    services.zfs
  ];

  # File Systems and Swap

  boot.supportedFilesystems = singleton "zfs";

  fileSystems = {
    "/" = {
      device = "zroot/safe/root";
      fsType = "zfs";
    };
    "/nix" = {
      device = "zroot/local/nix";
      fsType = "zfs";
    };
    "/home" = {
      device = "zroot/safe/home";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/44CC-7137";
      fsType = "vfat";
    };
    "/boot-fallback" = {
      device = "/dev/disk/by-uuid/4520-4E5F";
      fsType = "vfat";
    };
    "/mnt/zraw" = {
      device = "zstore/raw";
      fsType = "zfs";
    };
    "/mnt/zenc" = {
      device = "zstore/enc";
      fsType = "zfs";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/682df001-bad8-4d94-a86b-9068ce5eee4c"; }
    { device = "/dev/disk/by-uuid/1ee2d322-235c-41de-b272-7ceded4e2624"; }
  ];

  # Bootloader

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      mirroredBoots = [
        {
          devices = [ "/dev/disk/by-uuid/4520-4E5F" ];
          path = "/boot-fallback";
        }
      ];
    };
  };

  # Networking

  networking = {
    hostName = "beltane";
    hostId = "3ef9a419";
    useDHCP = false;
    interfaces.eno1.ipv4.addresses = singleton {
      inherit (config.network.addresses.private.ipv4) address;
      prefixLength = 24;
    };
    defaultGateway = config.network.privateGateway;
  };

  network = {
    addresses = {
      private = {
        ipv4.address = "192.168.1.2";
        # TODO ipv6.address
      };
    };
    yggdrasil = {
      enable = true;
      pubkey = "d3e488574367056d3ae809b678f799c29ebfd5c7151bb1f4051775b3953e5f52";
      listen.enable = false;
      listen.endpoints = [ "tcp://0.0.0.0:0" ];
    };
  };

  # Firewall

  kw.fw = {
    private.interfaces = singleton "yggdrasil";
    public.interfaces = singleton "eno1";
  };

  # Yggdrasil


  # State

  system.stateVersion = "21.05";

}

