{ config, lib, ... }:

/*
This hardware profile corresponds to the MSI B450-A PRO MAX system.
*/

with lib;

{
  deploy.profile.hardware.ms-7b86 = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "nct6775" ];
}
