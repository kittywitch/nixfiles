{ meta, config, pkgs, modulesPath, lib, ... }: with lib; {
  options.home-manager.users = let
    userNMExtend = { config, nixos, ... }: {
      services.network-manager-applet.enable = true;
    };
    userBase16Extend = { config, nixos, ... }: {
      base16.alias.default = "atelier.atelier-cave-light";
    };
  in mkOption {
    type = types.attrsOf (types.submoduleWith {
      modules = [ userNMExtend userBase16Extend ];
    });
  };

  imports = with meta; [
    profiles.gui
    users.kat.guiFull
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
  ];

  config = {
    networking = {
      networkmanager.enable = true;
    };

    system.stateVersion = "21.11";
  };
}
