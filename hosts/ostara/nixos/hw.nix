{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/469a684b-eb8f-48a8-8f98-be58528312c4";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/2223e305-79c9-45b3-90d7-560dcc45775a"; }
    ];

}
