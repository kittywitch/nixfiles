{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "nct6775" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "rpool/safe/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/safe/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AED6-D0D1";
    fsType = "vfat";
  };

  fileSystems."/mnt/zraw" = {
    device = "zstore/raw";
    fsType = "zfs";
  };

  fileSystems."/mnt/zcomp" = {
    device = "zstore/compress";
    fsType = "zfs";
  };

  fileSystems."/mnt/zenc" = {
    device = "zstore/protect";
    fsType = "zfs";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/89831a0f-93e6-4d30-85e4-09061259f140"; }
    { device = "/dev/disk/by-uuid/8f944315-fe1c-4095-90ce-50af03dd5e3f"; }
  ];

}
