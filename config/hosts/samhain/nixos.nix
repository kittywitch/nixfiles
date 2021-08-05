{ tf, config, users, pkgs, lib, profiles, sources, ... }:

with lib;

let
  hexchen = (import sources.hexchen) { };
  hexYgg = filterAttrs (_: c: c.enable)
    (mapAttrs (_: host: host.config.network.yggdrasil) hexchen.hosts);
in {
  # Imports

  imports = [
    profiles.hardware.ms-7b86
    profiles.gui
    profiles.vfio
    users.kat.guiFull
    ../../services/zfs.nix
    ../../services/restic.nix
    ../../services/nginx.nix
    ../../services/node-exporter.nix
    ../../services/promtail.nix
    ../../services/netdata.nix
    ./nixos/virtualhosts.nix
  ];

  # File Systems and Swap

  boot.supportedFilesystems = [ "zfs" "xfs" ];

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
      device = "/dev/disk/by-uuid/AED6-D0D1";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/89831a0f-93e6-4d30-85e4-09061259f140"; }
    { device = "/dev/disk/by-uuid/8f944315-fe1c-4095-90ce-50af03dd5e3f"; }
  ];

  # Bootloader

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Hardware

  deploy.profile.hardware.acs-override = true;

  hardware.openrazer = {
    enable = true;
  };
  environment.systemPackages = [ pkgs.razergenie ];

  boot.modprobe.modules = {
    vfio-pci = let
      vfio-pci-ids = [
        "1002:67df" "1002:aaf0" # RX 580
        "1912:0014" # Renesas USB 3
        "1022:149c" # CPU USB 3
      ];
    in mkIf (vfio-pci-ids != [ ]) {
      options.ids = concatStringsSep "," vfio-pci-ids;
    };
  };

  # Networking

  networking = {
    hostName = "samhain";
    hostId = "617050fc";
    useDHCP = false;
    useNetworkd = true;
    firewall.allowPing = true;
  };

  systemd.network = {
    networks.enp34s0 = {
      matchConfig.Name = "enp34s0";
      bridge = singleton "br";
    };
    networks.br = {
      matchConfig.Name = "br";
      address = [ "192.168.1.135/24" ];
      gateway = [ "192.168.1.254" ];
    };
    netdevs.br = {
      netdevConfig = {
        Name = "br";
        Kind = "bridge";
        MACAddress = "00:d8:61:c7:f4:9d";
      };
    };
  };

  services.avahi.enable = true;

  # Firewall

  kw.fw.private.interfaces = singleton "yggdrasil";
  kw.fw.public.interfaces = singleton "br";
  kw.fw.private.tcp.ports = [ 10445 ]; # VM Prometheus

  # Host-specific DNS Config

  kw.dns.dynamic = true;

  # Yggdrasil

  network.yggdrasil = {
    enable = true;
    pubkey = "a7110d0a1dc9ec963d6eb37bb6922838b8088b53932eae727a9136482ce45d47";
    # if server, enable this and set endpoint:
    listen.enable = false;
    listen.endpoints = [ "tcp://0.0.0.0:0" ];
  };

  # State

  system.stateVersion = "20.09";
}

