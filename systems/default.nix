{
  inputs,
  tree,
  lib,
  ...
}: let
  # The purpose of this file is to set up the host module which allows assigning of the system, e.g. aarch64-linux and the builder used with less pain.
  inherit (lib.lists) fold;
  inherit (lib.attrsets) mapAttrs mapAttrsToList recursiveUpdate;
  inherit (lib.strings) toLower;
  inherit (lib.options) mkOption;
  inherit (lib.types) str listOf attrs unspecified;
  inherit (lib.modules) evalModules;
  recursiveMergeAttrs = fold recursiveUpdate {};
  defaultSpecialArgs = {
    inherit inputs tree;
  };
  hostModule = {
    config,
    machine,
    ...
  }: {
    options = {
      arch = mkOption {
        description = "Processor architecture of the host";
        type = str;
        default = "x86_64";
      };
      type = mkOption {
        description = "Operating system type of the host";
        type = str;
        default = "NixOS";
      };
      folder = mkOption {
        type = str;
        internal = true;
      };
      system = mkOption {
        type = str;
        internal = true;
      };
      modules = mkOption {
        type = listOf unspecified;
      };
      specialArgs = mkOption {
        type = attrs;
        internal = true;
      };
      builder = mkOption {
        type = unspecified;
        internal = true;
      };
    };
    config = {
      system = let
        kernel =
          {
            nixos = "linux";
            macos = "darwin";
            darwin = "darwin";
            linux = "linux";
          }
          .${toLower config.type};
      in "${config.arch}-${kernel}";
      folder =
        {
          nixos = "nixos";
          macos = "darwin";
          darwin = "darwin";
          linux = "linux";
        }
        .${toLower config.type};
      modules = with tree; [
        tree.${config.folder}.modules
        system
      ];
      builder =
        {
          nixos = inputs.nixpkgs.lib.nixosSystem;
          darwin = inputs.darwin.lib.darwinSystem;
          macos = inputs.darwin.lib.darwinSystem;
        }
        .${toLower config.type};
      specialArgs =
        {
          inherit machine;
          systemType = config.folder;
        }
        // defaultSpecialArgs;
    };
  };
  hostConfigs = mapAttrs (name: path:
    evalModules {
      modules = [
        hostModule
        path
      ];
      specialArgs =
        defaultSpecialArgs
        // {
          machine = name;
        };
    })
  tree.systems;
  processHost = name: cfg: let
    host = cfg.config;
  in {
    "${host.folder}Configurations".${name} = let
      hostConfig = host.builder {
        inherit (host) system modules specialArgs;
      };
    in
      if host.folder == "nixos"
      then
        hostConfig.extendModules {
          modules = [inputs.scalpel.nixosModule];
          specialArgs = {
            prev = hostConfig;
          };
        }
      else hostConfig;
  };
in
  recursiveMergeAttrs (mapAttrsToList processHost hostConfigs)
