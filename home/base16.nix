{ config, pkgs, lib, ... }:

{
	kw.theme.enable = true;

	base16 = {
		shell.enable = true;
		schemes = lib.mkMerge [ {
			light = "atelier.atelier-cave-light";
			dark = "atelier.atelier-cave";
		} (lib.mkIf (true == false) {
			dark.ansi.palette.background.alpha = "ee00";
			light.ansi.palette.background.alpha = "d000";
		}) ];
		defaultSchemeName = "dark";
	};
}
