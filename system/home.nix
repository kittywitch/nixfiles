{ meta, config, lib, inputs, tf, ... }:

with lib;

{
  home-manager = {
    extraSpecialArgs = {
      inherit inputs tf meta;
      nixos = config;
    };
    sharedModules = [
      meta.modules.home
    ];
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
