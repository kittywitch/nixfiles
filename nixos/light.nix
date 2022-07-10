{ config, lib, ... }: with lib; {
  options.home-manager.users = let
    lightModeExtend = { config, nixos, ... }: {
      gtk.iconTheme.name = mkForce "Papirus-Light";
      base16 = {
        alias.default = "atelier.atelier-cave-light";
        defaultSchemeName = "atelier.atelier-cave-light";
      };
    };
  in mkOption {
    type = types.attrsOf (types.submoduleWith {
      modules = singleton lightModeExtend;
    });
  };
}
