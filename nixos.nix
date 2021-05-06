{ pkgs, config, lib, sources, tf, witch, options, hostName, ... }:

{

  imports =
    [ (import (./hosts + "/${hostName}/nixos")) ./profiles/common/nixos.nix ]
    ++ lib.optional
    (builtins.pathExists (./private/hosts + "/${hostName}/nixos"))
    (import (./private/hosts + "/${hostName}/nixos"))
    ++ lib.optional (builtins.pathExists ./private/profile)
    ./private/profile/nixos;

  options = {
    deploy.profile.gui = lib.mkEnableOption "graphical system";
    deploy.profile.sway = lib.mkEnableOption "sway wm";
    deploy.profile.laptop = lib.mkEnableOption "lappytop";
  };

  options.home-manager.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submoduleWith {
      modules = [ ];
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
          imports = [ ./home.nix ] ++ lib.optional
            (builtins.pathExists (./hosts + "/${hostName}/home"))
            (import (./hosts + "/${hostName}/home")) ++ lib.optional
            (builtins.pathExists (./private/hosts + "/${hostName}/home"))
            (import (./private/hosts + "/${hostName}/home"));

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
