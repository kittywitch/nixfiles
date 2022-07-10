{ config, lib, ... }:

/*
  This hardware profile corresponds to the Lenovo Thinkpad x270.
*/

let
  inherit (lib.options) mkOption;
in {
  options.home-manager.users = let
    userTouchpadExtend = { config, nixos, ... }: {
      wayland.windowManager.sway.config.input."2:7:SynPS/2_Synaptics_TouchPad" = {
        dwt = "enabled";
        tap = "enabled";
        natural_scroll = "enabled";
        middle_emulation = "enabled";
        click_method = "clickfinger";
      };
    };
    waybarExtend = { config, ... }: {
      options = {
        programs.waybar.settings = mkOption {
          type = lib.types.either (lib.types.listOf (lib.types.submodule waybarExtend2)) (lib.types.attrsOf (lib.types.submodule waybarExtend2));
        };
      };
    };
    waybarExtend2 = { config, ... }: {
      config = {
        modules.temperature.hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp2_input";
      };
    };
  in mkOption {
    type = lib.types.attrsOf (lib.types.submoduleWith {
      modules = [ userTouchpadExtend waybarExtend ];
    });
  };

  config = {
    boot = {
      initrd.availableKernelModules =
      [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
      kernelModules = [ "kvm-intel" ];
    };
  };
}
