{ config, lib, ... }:

/*
	 This hardware profile corresponds to the Lenovo Thinkpad x270.
 */

let
inherit (lib.options) mkOption;
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
		modules.temperature.hwmon-path = "/sys/devices/platform/thinkpad_hwmon/hwmon/hwmon6/temp1_input";
	};
};
in {
	home-manager.sharedModules = [
		waybarExtend
			userTouchpadExtend
	];
	boot = {
		initrd.availableKernelModules =
			[ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
		kernelModules = [ "kvm-intel" ];
	};
}
