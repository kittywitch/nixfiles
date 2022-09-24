{ meta, config, lib, pkgs, modulesPath, ... }:

{
  imports = with meta; [
    (modulesPath + "/installer/scan/not-detected.nix")
    hardware.local
    nixos.network
    ./kanidm.nix
    ./vouch.nix
    ./home-assistant.nix
    ./zigbee2mqtt.nix
    ./mosquitto.nix
    ./postgres.nix
    ./nginx.nix
  ];

  networks = {
    gensokyo = {
      interfaces = [
        "eno1"
      ];
      ipv4 = "10.1.1.38";
    };
  };

  networking = {
    useDHCP = false;
    interfaces = {
      eno1 = {
        useDHCP = true;
      };
    };
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    };
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6c5d82b1-5d11-4c72-96c6-5f90e6ce57f5";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/85DC-72FA";
      fsType = "vfat";
    };
  };

  swapDevices = lib.singleton ({
    device = "/dev/disk/by-uuid/137605d3-5e3f-47c8-8070-6783ce651932";
  });

  system.stateVersion = "21.05";
}
