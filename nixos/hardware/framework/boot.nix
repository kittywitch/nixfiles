{config, ...}: {
  # https://github.com/NixOS/nixos-hardware/issues/1581
  hardware.framework.enableKmod = false;

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
    };
    kernelModules = ["cros_ec" "cros_ec_lpcs"];
    extraModprobeConfig = "options snd_hda_intel power_save=0";
    extraModulePackages = with config.boot.kernelPackages; [
      framework-laptop-kmod
    ];
  };
}
