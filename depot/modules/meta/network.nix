{ pkgs, sources, lib, meta, config, ... }:

/*
This module:
  * Makes hosts nixosModules.
  * Manages module imports and specialArgs.
  * Builds network.nodes.
*/

with lib;

{
  options.network = {
    nixos = {
      extraModules = mkOption {
        type = types.listOf types.unspecified;
        default = [ ];
      };
      specialArgs = mkOption {
        type = types.attrsOf types.unspecified;
        default = { };
      };
      modulesPath = mkOption {
        type = types.path;
        default = toString (pkgs.path + "/nixos/modules");
      };
    };
    nodes = let
      nixosModule = { name, config, meta, modulesPath, lib, ... }: with lib; {
        config = {
          nixpkgs = {
            system = mkDefault pkgs.system;
            pkgs = mkDefault pkgs;
          };
        };
      };
      nixosType = let
        baseModules = import (config.network.nixos.modulesPath + "/module-list.nix");
      in types.submoduleWith {
        modules = baseModules
        ++ singleton nixosModule
        ++ config.network.nixos.extraModules;

        specialArgs = {
          inherit baseModules;
          inherit (config.network.nixos) modulesPath;
        } // config.network.nixos.specialArgs;
      };
    in mkOption {
      type = types.attrsOf nixosType;
      default = { };
    };
  };
  config.network = {
    nixos = {
      extraModules = [
        "${toString sources.home-manager}/nixos"
        ../../modules/nixos
      ];
      specialArgs = {
        inherit (config.network) nodes;
        inherit sources meta;
      };
    };
  };
}
