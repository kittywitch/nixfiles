{lib, ...}: let
in {
  boot = {
    initrd.availableKernelModules =
      [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
    kernelModules = [ "kvm-intel" ];
  };
  home-manager.sharedModules = [
  {
    wayland.windowManager.sway.config.input."2:7:SynPS/2_Synaptics_TouchPad" = {
      dwt = "enabled";
      tap = "enabled";
      natural_scroll = "enabled";
      middle_emulation = "enabled";
      click_method = "clickfinger";
    };
  }
  ];
}
