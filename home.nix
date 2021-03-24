{ pkgs, config, lib, witch, ... }:
let
  homeModules = witch.modList {
    modulesDir = ./profiles;
    defaultFile = "home.nix";
  };
in {

  imports = lib.attrValues homeModules
    ++ [ ./modules/home ./private/profile/home ];
}

