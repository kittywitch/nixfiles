{ meta, config, lib, pkgs, modulesPath, ... }:

{
  imports = with meta; [
    (modulesPath + "/installer/scan/not-detected.nix")
    nixos.network
    ./home-assistant.nix
    ./zigbee2mqtt.nix
    ./mosquitto.nix
    ./postgres.nix
  ];

  deploy.tf = {
    resources.tewi = {
      provider = "null";
      type = "resource";
      connection = {
        port = lib.head config.services.openssh.ports;
        host = config.network.addresses.private.nixos.ipv4.address;
      };
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

  network = {
    firewall = {
      public.interfaces = lib.singleton "eno1";
    };
    addresses = {
      private = {
        enable = true;
        nixos = {
          ipv4.address = "10.1.1.38";
        };
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
