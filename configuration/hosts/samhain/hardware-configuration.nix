# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "zroot/safe/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "zroot/safe/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/50C3-BE99";
      fsType = "vfat";
    };

  fileSystems."/disks/pool-protect" =
    { device = "zstore/protect";
      fsType = "zfs";
    };

  fileSystems."/disks/pool-raw" =
    { device = "zstore/raw";
      fsType = "zfs";
    };

  fileSystems."/disks/pool-compress" =
    { device = "zstore/compress";
      fsType = "zfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/88595373-9566-401b-8c9b-03bbc8314f1b"; }
    ];

}
