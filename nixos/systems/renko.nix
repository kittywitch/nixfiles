{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
  ];


    deploy.tf = {
      resources.renko = {
        provider = "null";
        type = "resource";
        connection = {
          port = builtins.head config.services.openssh.ports;
          host = "192.168.64.3";
        };
      };
    };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [ "ehci_pci" "uhci_hcd" "ahci" "usbhid" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a4b4dea9-dd55-4055-9c98-49349ec43e5c";
      fsType = "ext4";
    };
  "/boot" = {
      device = "/dev/disk/by-uuid/957B-56F1";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/59399595-6a74-480c-b98c-e356761c0861"; }
  ];

  networking.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault false;

  system.stateVersion = "22.05";
}
