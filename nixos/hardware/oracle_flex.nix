{ modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.supportedFilesystems = [ "xfs" ];
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/92B6-AAE1"; fsType = "vfat"; };
  fileSystems."/" = { device = "/dev/sda3"; fsType = "xfs"; };
  swapDevices = [ { device = "/dev/sda2"; } ];
  boot = {
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