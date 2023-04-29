{
  meta,
  config,
  lib,
  inputs,
  ...
}:
with lib; {
  home-manager = {
    extraSpecialArgs = {
      inherit inputs meta;
      nixos = config;
    };
    sharedModules = [
      meta.modules.home
    ];
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
