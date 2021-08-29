{ meta, config, pkgs, lib, ... }:

with lib;

{
  # Imports

  imports = with meta; [
    profiles.hardware.v330-14arr
    profiles.gui
    users.kat.guiFull
    services.nginx
    services.restic
    services.zfs
  ];

  # Terraform

  deploy.tf = {
    resources.yule = {
      provider = "null";
      type = "resource";
      connection = {
        port = head config.services.openssh.ports;
        host = config.network.addresses.private.ipv4.address;
      };
    };
  };

  # File Systems and Swap

  boot.supportedFilesystems = singleton "zfs";

  fileSystems = {
    "/" = {
      device = "rpool/safe/root";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/safe/home";
      fsType = "zfs";
    };
    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/2552-18F2";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/87ff4f68-cc00-494e-8eba-050469c3bf03"; }];

  # Bootloader

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking

  networking = {
    hostId = "dddbb888";
    hostName = "yule";
    useDHCP = false;
    wireless.interfaces = singleton "wlp2s0";
    interfaces = {
      wlp2s0.ipv4.addresses = singleton {
        inherit (config.network.addresses.private.ipv4) address;
        prefixLength = 24;
      };
    };
    defaultGateway = config.network.privateGateway;
  };

  network = {
    addresses = {
      private = {
        enable = true;
        ipv4.address = "192.168.1.3";
      };
    };
    yggdrasil = {
      enable = true;
      pubkey = "9779fd6b5bdba6b9e0f53c96e141f4b11ce5ef749d1b9e77a759a3fdbd33a653";
      listen.enable = false;
      listen.endpoints = [ "tcp://0.0.0.0:0" ];
    };
  };

  # Firewall

  network.firewall = {
    public.interfaces = [ "enp1s0" "wlp2s0" ];
    private.interfaces = singleton "yggdrasil";
  };

  # State

  system.stateVersion = "20.09";
}

