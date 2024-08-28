{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  zramSwap.enable = true;
  boot = {
    tmp.cleanOnBoot = true;
    loader = {
      grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
        configurationLimit = 1;
      };
      systemd-boot.configurationLimit = 1;
      initrd = {
        availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
        kernelModules = ["nvme"];
      };
    };
  };
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/1F52-C11D";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
  };
}
