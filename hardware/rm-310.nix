{ config, ... }:

/*
  This hardware profile corresponds with the RM DESKTOP 310 system, which is actually just an Intel DQ67OW motherboard.
*/

{
  boot.initrd.availableKernelModules = [ "ata_generic" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
}
