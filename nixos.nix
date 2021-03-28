{ pkgs, config, lib, sources, witch, options, hostName, ... }:

{

  imports = [
    (import (./hosts + "/${hostName}/nixos"))
    (import (./private/hosts + "/${hostName}/nixos"))
    ./profiles/common/nixos.nix
    ./private/profile/nixos 
  ];

  options.home-manager.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submoduleWith {
      modules = [ ];
      specialArgs = {
        inherit sources witch hostName;
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
          imports = [ ./home.nix (import (./hosts + "/${hostName}/home")) ];
        };
      };
    };
  };
}
