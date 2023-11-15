{
  inputs,
  tree,
  lib,
  std,
  ...
}: let
  # The purpose of this file is to set up the host module which allows assigning of the system, e.g. aarch64-linux and the builder used with less pain.
  inherit (lib.modules) evalModules;
  inherit (std) string types optional set;
  defaultSpecialArgs = {
    inherit inputs tree std;
  };
  hostModule = {
    config,
    machine,
    ...
  }: {
    options = let
      inherit (lib.types) str listOf attrs unspecified;
      inherit (lib.options) mkOption;
    in {
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
          .${string.toLower config.type};
      in "${config.arch}-${kernel}";
      folder =
        {
          nixos = "nixos";
          macos = "darwin";
          darwin = "darwin";
          linux = "linux";
        }
        .${string.toLower config.type};
      modules = with tree; [
        # per-OS modules
        tree.modules.${config.folder}
        # per-OS configuration
        tree.${config.folder}.common
        # per-OS user definition
        tree.home.user.${config.folder}
        # the base common module
        common
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
            args: let
              nixos = sys args;
            in
              nixos.extendModules {
                modules =
                  nixos.config.scalpels
                  ++ [
                    inputs.scalpel.nixosModules.scalpel
                  ];
                specialArgs = {prev = nixos;};
              };
          darwin = inputs.darwin.lib.darwinSystem;
          macos = inputs.darwin.lib.darwinSystem;
        }
        .${string.toLower config.type};
      specialArgs =
        {
          inherit machine;
          systemType = config.folder;
          inherit (config) system;
        }
        // defaultSpecialArgs;
    };
  };
  hostConfigs = set.map (name: path:
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
    deploy.nodes = set.merge [
      (set.optional (host.folder == "nixos") {
        ${name} = {
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.${name};
          };
          autoRollback = true;
          magicRollback = true;
        };
      })
      (set.optional (name != "renko" && host.folder == "nixos") {
        ${name} = {
          hostname = "${name}.inskip.me";
          sshUser = "deploy";
          sshOpts = ["-oControlMaster=no" "-oControlPath=/tmp/willneverexist" "-p" "${builtins.toString (builtins.head inputs.self.nixosConfigurations.${name}.config.services.openssh.ports)}"];
        };
      })
      (set.optional (name == "renko" && host.folder == "nixos") {
        ${name} = {
          sshUser = "nixos";
          hostname = "orb";
          fastConnection = true;
          sshOpts = ["-oControlMaster=no" "-oControlPath=/tmp/willneverexist" "-p" "32222"];
        };
      })
    ];

    "${host.folder}Configurations".${name} = host.builder {
      inherit (host) system modules specialArgs;
    };
  };
in
  set.merge (set.mapToValues processHost hostConfigs)
