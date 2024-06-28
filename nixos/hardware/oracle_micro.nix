{ modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/1F52-C11D"; fsType = "vfat"; };
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

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