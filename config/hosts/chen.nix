{ meta, config, pkgs, lib, ... }:

with lib;

{
  # Imports

  imports = with meta; [
    profiles.hardware.eeepc-1015pem
    profiles.network
    services.kattv2
    services.dnscrypt-proxy
  ];

  # Terraform

  deploy.tf = {
    resources.chen = {
      provider = "null";
      type = "resource";
      connection = {
        port = head config.services.openssh.ports;
        host = config.network.addresses.private.nixos.ipv4.address;
      };
    };
  };

  # File Systems and Swap

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/fa06ba90-ffc9-4ca6-b1cf-1205340a975e";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/BF39-2AA3";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/9c88235e-9705-4b80-a988-e95eda06124f"; }
    ];

  # Bootloader

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "usb_storage" "sd_mod" "sdhci_acpi" ];
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Hardware

  services.logind.lidSwitchExternalPower = "ignore";

  # Networking

  networking = {
    hostId = "9f89b327";
    useDHCP = false;
    wireless = {
      enable = false;
      userControlled.enable = false;
      interfaces = singleton "wlp1s0";
    };
    interfaces.enp0s20u1.ipv4.addresses = singleton {
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
          ipv4.address = "192.168.1.34";
        };
      };
    };
  };

  # Firewall

  network.firewall = {
    public = {
      interfaces = singleton "enp0s20u1";
    };
  };

  # State

  system.stateVersion = "20.09";
}
