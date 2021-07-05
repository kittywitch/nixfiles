{ pkgs, config, lib, tf, sources, options, profiles, ... }:

{
  imports = [
    profiles/common
  ];

  options = {
    deploy.profile.gui = lib.mkEnableOption "graphical system";
    deploy.profile.fvwm = lib.mkEnableOption "fvwm";
    deploy.profile.sway = lib.mkEnableOption "sway wm";
    deploy.profile.laptop = lib.mkEnableOption "lappytop";
    home-manager.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submoduleWith {
        modules = [ ./modules/home ];
        specialArgs = {
          inherit sources tf;
          superConfig = config;
          modulesPath = sources.home-manager + "/modules";
        };
      });
    };
  };

  config = {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users = {
        kat = {
          imports = lib.optional (builtins.pathExists ./trusted/users/kat) (import ./trusted/users/kat);

          options = {
            deploy.profile.gui = lib.mkEnableOption "graphical system";
            deploy.profile.sway = lib.mkEnableOption "sway wm";
            deploy.profile.laptop = lib.mkEnableOption "lappytop";
          };
        };
        kairi = {
          imports = lib.optional (builtins.pathExists ./trusted/users/kairi) (import ./trusted/users/kairi);

          options = {
            deploy.profile.gui = lib.mkEnableOption "graphical system";
            deploy.profile.fvwm = lib.mkEnableOption "fvwm";
            deploy.profile.laptop = lib.mkEnableOption "lappytop";
          };
        };
      };
    };
  };
}
