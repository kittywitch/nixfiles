{ meta, config, lib, sources, tf, ... }:

with lib;

{
  options.home-manager.users = mkOption {
    type = types.attrsOf (types.submoduleWith {
      modules = singleton ../../modules/home;
      specialArgs = {
        inherit sources tf meta;
        nixos = config;
        modulesPath = sources.home-manager + "/modules";
      };
    });
  };

  config = {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}
