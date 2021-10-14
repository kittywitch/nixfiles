{ meta, config, lib, sources, tf, ... }:

with lib;

{
  options.home-manager.users = mkOption {
    type = types.attrsOf (types.submoduleWith {
      modules = singleton meta.modules.home;
      specialArgs = {
        inherit sources tf meta;
        nixos = config;
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
