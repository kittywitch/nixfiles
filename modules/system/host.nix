{
  name,
  config,
  tree,
  std,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib.modules) mkIf mkOptionDefault mkMerge;
  inherit (lib.trivial) mapNullable;
  inherit (std) string set;
in {
  options = let
    inherit (lib.types) str listOf attrs nullOr unspecified enum bool;
    inherit (lib.options) mkOption;
  in {
    name = mkOption {
      type = str;
      default = name;
      readOnly = true;
    };
    arch = mkOption {
      description = "Processor architecture of the host";
      type = str;
      default = "x86_64";
    };
    type = mkOption {
      description = "Operating system type of the host";
      type = enum ["NixOS" "MacOS" "Darwin" "Linux" "Windows" "Home"];
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
      default = [];
    };
    specialArgs = mkOption {
      type = attrs;
      internal = true;
    };
    builder = mkOption {
      type = unspecified;
      internal = true;
    };
    built = mkOption {
      type = unspecified;
      internal = true;
    };
    microVM = {
      state = mkOption {
        description = "Does this system exist as a guest MicroVM?";
        type = bool;
        default = false;
      };
      host = mkOption {
        description = "The hostname that is the host of this guest MicroVM";
        type = nullOr str;
        default = null;
      };
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
          home = "linux";
        }
        .${
          string.toLower config.type
        };
    in "${config.arch}-${kernel}";
    folder =
      {
        nixos = "nixos";
        macos = "darwin";
        darwin = "darwin";
        linux = "linux";
        windows = "windows";
        home = "home";
      }
      .${
        string.toLower config.type
      };
    modules = mkMerge [
      (mkIf (config.folder != "linux") [
        # per-OS modules
        tree.modules.${config.folder}
        # per-OS user definition
        tree.home.user.${config.folder}
      ])
      (mkIf (config.folder != "linux" && config.folder != "home") [
        # per-OS configuration
        tree.${config.folder}.common
        # true base module
        tree.common
      ])
    ];
    builder =
      {
        nixos = let
          lib = inputs.nixpkgs.lib.extend (self: super:
            import (inputs.arcexprs + "/lib") {
              inherit super;
              lib = self;
              isOverlayLib = true;
            });
          sys = args:
            lib.nixosSystem ({
                inherit lib;
              }
              // args);
        in
          sys;
        home = args: let
          renamedArgs = set.rename "specialArgs" "extraSpecialArgs" args;
          renamedArgsWithPkgs =
            renamedArgs
            // {
              inherit lib;
              pkgs = pkgs.${args.system};
            };
          attrsToRemove = ["configuration" "username" "homeDirectory" "stateVersion" "extraModules" "system"];
          safeArgs = removeAttrs renamedArgsWithPkgs attrsToRemove;
        in
          inputs.home-manager.lib.homeManagerConfiguration safeArgs;
        darwin = inputs.darwin.lib.darwinSystem;
        macos = inputs.darwin.lib.darwinSystem;
      }
      .${
        string.toLower config.type
      }
      or null;
    built = mkOptionDefault (mapNullable (builder:
      builder {
        inherit (config) system modules specialArgs;
      })
    config.builder);
    specialArgs = {
      inherit name inputs std tree;
      systemType = config.folder;
      nur = import inputs.nur {
        pkgs = pkgs.${config.system};
        nurpkgs = pkgs.${config.system};
      };
      machine = name;
      system = config;
    };
  };
}
