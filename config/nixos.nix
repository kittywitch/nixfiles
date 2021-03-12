{ pkgs, config, lib, sources, witch, options, ... }:

let
  nixosModules = witch.modList {
    modulesDir = ./profiles;
    defaultFile = "nixos.nix";
  };
in {

  imports = lib.attrValues nixosModules;

  options.home-manager.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submoduleWith {
      modules = [ ];
      specialArgs = {
        inherit sources witch;
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
          imports = [ ./home.nix ];

          deploy.profile = lib.mkMerge (map (prof: {
            ${if options ? deploy.profile.${prof} then prof else null} = true;
          }) config.deploy.profiles);
        };
      };
    };
  };
}
