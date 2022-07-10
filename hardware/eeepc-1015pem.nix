{ config, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
    kernelParams = [
      "usbcore.autosuspend=-1"
      "acpi_osi=Linux"
      "acpi_enforce_resources=lax"
    ];
  };
}
