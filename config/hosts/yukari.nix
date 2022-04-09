{ meta, tf, config, pkgs, lib, ... }: with lib; {
  imports = with meta; [
    profiles.hardware.rm-310
    profiles.network
    services.ha
    services.nextcloud
    services.kattv-ingest
    services.kattv2-ingest
    services.postgres
    services.nfs
    services.nginx
    services.transmission
    services.tvheadend
    services.zfs
    services.plex
    users.arc
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
      device = "rpool/safe/root";
      fsType = "zfs";
    };
    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/safe/home";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_250GB_S3YJNX0K780441Z-part3";
      fsType = "vfat";
    };
    "/boot-fallback" = {
      device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S3R0NF1J841629N-part3";
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
    { device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_250GB_S3YJNX0K780441Z-part2"; }
    { device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S3R0NF1J841629N-part2"; }
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      mirroredBoots = [
        {
          devices = [ "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S3R0NF1J841629N-part3" ];
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
    interfaces.eno1 = {
      useDHCP = true;
      tempAddress = "disabled";
    }; /*.ipv4.addresses = singleton {
      inherit (config.network.addresses.private.nixos.ipv4) address;
      prefixLength = 24;
    };
    defaultGateway = config.network.privateGateway; */
  };

  network = {
    addresses = {
      private = {
        enable = true;
        nixos = {
          ipv4.address = "192.168.1.154";
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

