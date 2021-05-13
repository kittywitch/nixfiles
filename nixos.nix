{ pkgs, config, lib, sources, tf, witch, options, profiles, hostName, ... }:

{

  imports =
    [ (import (./hosts + "/${hostName}/nixos")) profiles.common ]
    # trusted check
    ++ lib.optional (builtins.pathExists (./trusted/hosts + "/${hostName}/nixos")) (import (./trusted/hosts + "/${hostName}/nixos"))
    # trusted default check
    ++ lib.optional (builtins.pathExists ./trusted/hosts) (import ./trusted/hosts)
    # trusted profile check
    ++ lib.optional (builtins.pathExists ./trusted/profile) (import ./trusted/profile);

  options = {
    deploy.profile.gui = lib.mkEnableOption "graphical system";
    deploy.profile.sway = lib.mkEnableOption "sway wm";
    deploy.profile.laptop = lib.mkEnableOption "lappytop";
  };

  options.home-manager.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submoduleWith {
      modules = [ ./modules/home ];
      specialArgs = {
        inherit sources witch hostName tf;
        superConfig = config;
        modulesPath = sources.home-manager + "/modules";
      };
    });
  };

  config = {
    home-manager = {

      useUserPackages = true;
      useGlobalPkgs = true;

      users = {
        kat = {
          imports = lib.optional (builtins.pathExists (./hosts + "/${hostName}/home")) (import (./hosts + "/${hostName}/home"))
            # trusted hosts check
            ++ lib.optional (builtins.pathExists (./trusted/hosts + "/${hostName}/home")) (import (./trusted/hosts + "/${hostName}/home"))
            # trusted users check 
            ++ lib.optional (builtins.pathExists ./trusted/users) (import ./trusted/users);

          options = {
            deploy.profile.gui = lib.mkEnableOption "graphical system";
            deploy.profile.sway = lib.mkEnableOption "sway wm";
            deploy.profile.laptop = lib.mkEnableOption "lappytop";
          };
        };
      };
    };
  };
}
