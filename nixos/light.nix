{ config, lib, ... }: with lib; let
lightModeExtend = { config, nixos, ... }: {
	gtk.iconTheme.name = mkForce "Papirus-Light";
	base16 = {
		defaultSchemeName = mkForce "light";
	};
};
in {
	home-manager.sharedModules = [
		lightModeExtend
	];
}
