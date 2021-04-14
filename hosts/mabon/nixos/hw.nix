{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/236f9363-19ee-46e3-8db4-5dd1e28b742d";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/b0435b6c-fd76-44d0-8b63-2c2c059df814";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/84FB-4F88";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/926c41d6-c06a-4dcc-b55d-f4cfaafe4bac"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
