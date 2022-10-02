{ meta, config, lib, inputs, tf, ... }:

with lib;

{
  home-manager = {
    extraSpecialArgs = {
      inherit inputs tf meta;
      nixos = config;
    };
    sharedModules = [
      inputs.nix-doom-emacs.hmModule
      meta.modules.home
      meta.modules.type
    ];
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
