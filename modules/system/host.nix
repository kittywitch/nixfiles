{
  name,
  config,
  meta,
  std,
  Std,
  lib,
  inputs,
  ...
}: let
  inherit (lib.modules) mkIf mkOptionDefault;
  inherit (lib.trivial) mapNullable;
  inherit (std) string;
in {
  options = let
    inherit (lib.types) str listOf attrs unspecified enum;
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
      type = enum ["NixOS" "MacOS" "Darwin" "Linux" "Windows"];
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
        .${string.toLower config.type};
    in "${config.arch}-${kernel}";
    folder =
      {
        nixos = "nixos";
        macos = "darwin";
        darwin = "darwin";
        linux = "linux";
        windows = "windows";
      }
      .${string.toLower config.type};
    modules = mkIf (config.folder != "linux") [
      # per-OS modules
      meta.modules.${config.folder}
      # per-OS configuration
      meta.${config.folder}.base
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
        darwin = inputs.darwin.lib.darwinSystem;
        macos = inputs.darwin.lib.darwinSystem;
      }
      .${string.toLower config.type}
      or null;
    built = mkOptionDefault (mapNullable (builder:
      builder {
        inherit (config) system modules specialArgs;
      })
    config.builder);
    specialArgs = {
      inherit name inputs std Std meta;
      inherit (inputs.self.lib) gensokyo-zone;
      systemType = config.folder;
      system = config;
    };
  };
}
