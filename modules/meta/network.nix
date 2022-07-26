{ pkgs, inputs, lib, meta, config, ... }:

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
    darwin = {
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
        default = toString (inputs.darwin + "/modules");
      };
    };
    nodes.all = mkOption {
      type = types.attrsOf types.unspecified;
      default = config.network.nodes.nixos // config.network.nodes.darwin;
    };
    nodes.nixos =
      let
        nixosModule = { name, config, meta, modulesPath, lib, ... }: with lib; {
          options = {
            nixpkgs.crossOverlays = mkOption {
              type = types.listOf types.unspecified;
              default = [ ];
            };
          };
          config = {
            nixpkgs = {
              system = mkDefault "x86_64-linux";
              pkgs =
                let
                  pkgsReval = import pkgs.path {
                    inherit (config.nixpkgs) localSystem crossSystem crossOverlays;
                    inherit (pkgs) overlays config;
                  };
                in
                mkDefault (if config.nixpkgs.config == pkgs.config && config.nixpkgs.system == pkgs.targetPlatform.system then pkgs else pkgsReval);
            };
          };
        };
        nixosType =
          let
            baseModules = import (config.network.nixos.modulesPath + "/module-list.nix");
          in
          types.submoduleWith {
            modules = baseModules
              ++ singleton nixosModule
              ++ config.network.nixos.extraModules;

            specialArgs = {
              inherit baseModules;
              inherit (config.network.nixos) modulesPath;
            } // config.network.nixos.specialArgs;
          };
      in
      mkOption {
        type = types.attrsOf nixosType;
        default = { };
      };
    nodes.darwin =
      let
        darwinModule = { name, config, meta, modulesPath, lib, ... }: with lib; {
          config = {
            _module.args.pkgs = pkgs;
            nixpkgs = {
              system = mkDefault pkgs.system;
            };
          };
        };
        darwinType =
          let
            baseModules = import (config.network.darwin.modulesPath + "/module-list.nix");
            flakeModule = (config.network.darwin.modulesPath + "/system/flake-overrides.nix");
          in
          types.submoduleWith {
            modules = baseModules
              ++ singleton darwinModule
              ++ singleton flakeModule
              ++ config.network.darwin.extraModules;

            specialArgs = {
              inherit baseModules;
              inherit (config.network.darwin) modulesPath;
            } // config.network.darwin.specialArgs;
          };
      in
      mkOption {
        type = types.attrsOf darwinType;
        default = { };
      };
  };
  config.network = {
    darwin = {
      extraModules = [
        inputs.home-manager.darwinModules.home-manager
        meta.modules.darwin
        meta.modules.system
        meta.system
      ];
      specialArgs = {
        inherit (config.network) nodes;
        inherit inputs meta;
      };
    };
    nixos = {
      extraModules = [
        inputs.home-manager.nixosModules.home-manager
        meta.modules.nixos
        meta.modules.system
        meta.system
      ];
      specialArgs = {
        inherit (config.network) nodes;
        inherit inputs meta;
      };
    };
  };
}
