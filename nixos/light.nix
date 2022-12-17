{ config, lib, ... }: with lib; let
lightModeExtend = { config, nixos, ... }: {
	base16 = {
		defaultSchemeName = mkForce "light";
	};
};
in {
	home-manager.sharedModules = [
		lightModeExtend
	];
}
