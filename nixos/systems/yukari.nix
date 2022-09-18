{ meta, tf, config, pkgs, lib, ... }: with lib; {
  imports = with meta; [
    hardware.rm-310
    nixos.network
    nixos.arc
    services.ha
    services.nextcloud
    #services.kattv-ingest
    #services.kattv2-ingest
    services.postgres
    services.nfs
    services.nginx
    services.tvheadend
    services.zfs
    services.plex
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
    };
  };

  networks.chitei = {
    interfaces = [ "eno1" ];
    ipv4 = "100.98.152.108";
  };

  system.stateVersion = "21.05";

}

