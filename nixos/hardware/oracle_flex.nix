{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  zramSwap.enable = true;
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/92B6-AAE1";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/sda3";
      fsType = "xfs";
    };
  };
  swapDevices = [{device = "/dev/sda2";}];
  boot = {
    supportedFilesystems = ["xfs"];
    tmp.cleanOnBoot = true;
    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
      kernelModules = ["nvme"];
    };
    loader = {
      grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
        configurationLimit = 1;
      };
      systemd-boot.configurationLimit = 1;
    };
  };
}
