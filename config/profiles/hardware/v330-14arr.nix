{ config, ... }:

/*
  This hardware profile corresponds to the Lenovo IdeaPad v330-14ARR.
*/

{
  deploy.profile.hardware.v330-14arr = true;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
}
