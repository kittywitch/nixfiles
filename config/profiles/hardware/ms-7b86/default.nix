{ config, lib, ... }:

/*
This hardware profile corresponds to the MSI B450-A PRO MAX system.
*/

with lib;

{
  deploy.profile.hardware.ms-7b86 = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "nct6775" ];

  systemd.network = {
    networks.enp34s0 = {
      matchConfig.Name = "enp34s0";
      bridge = singleton "br";
    };
    networks.br = {
      matchConfig.Name = "br";
      address = [ "192.168.1.135/24" ];
      gateway = [ "192.168.1.254" ];
    };
    netdevs.br = {
      netdevConfig = {
        Name = "br";
        Kind = "bridge";
        MACAddress = "00:d8:61:c7:f4:9d";
      };
    };
  };
}
