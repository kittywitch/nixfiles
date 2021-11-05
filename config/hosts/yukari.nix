{ meta, tf, config, pkgs, lib, ... }: with lib; {
  imports = with meta; [
    profiles.hardware.rm-310
    profiles.network
    profiles.gui
    users.kat.guiFull
    services.jellyfin
    services.kattv-ingest
    services.kattv2-ingest
    services.postgres
    services.nfs
    services.nginx
    services.transmission
    services.tvheadend
    services.zfs
  ];

  deploy.tf = {
    resources.yukari = {
      provider = "null";
      type = "resource";
      connection = {
        port = head config.services.openssh.ports;
        host = config.network.addresses.private.nixos.ipv4.address;
      };
    };
  };

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

  hardware.displays."VGA-1" = {
    res = "1280x1024@75Hz";
    pos = "1920 0";
  };

  networking = {
    hostId = "3ef9a419";
    useDHCP = false;
    interfaces.eno1.ipv4.addresses = singleton {
      inherit (config.network.addresses.private.nixos.ipv4) address;
      prefixLength = 24;
    };
    defaultGateway = config.network.privateGateway;
  };

  network = {
    addresses = {
      private = {
        enable = true;
        nixos = {
          ipv4.address = "192.168.1.2";
          # TODO ipv6.address
        };
      };
    };
    yggdrasil = {
      enable = true;
      pubkey = "4f8fb0817afcd6211fb6a2cac2893df7d3f12c5c99eed106718d7223468473b2";
      address = "201:c1c1:3dfa:140c:a77b:8125:74d4:f5db";
      listen.enable = false;
      listen.endpoints = [ "tcp://0.0.0.0:0" ];
    };
    firewall = {
      private.interfaces = singleton "yggdrasil";
      public.interfaces = singleton "eno1";
    };
  };

  system.stateVersion = "21.05";

}

