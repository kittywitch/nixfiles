_: {
  boot = {
    plymouth = {
      enable = true;
    };
    consoleLogLevel = 0;
    kernelParams = [ "quiet" ];
    initrd = {
      verbose = false;
      systemd.enable = true;
      availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
    };
  };
}
