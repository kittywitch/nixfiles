{
  utils,
  nixpkgs,
  darwin,
  home-manager,
  ragenix,
  scalpel,
  nix-index-database,
  arcexprs,
  ...
} @ inputs: let
  tree =
    (inputs.tree.tree {
      inherit inputs;
      folder = ./.;
      config = {
        "/" = {
          excludes = [
            "flake"
            "default"
          ];
        };
        "darwin/modules" = {
          functor = {
            enable = true;
            external = [
              home-manager.darwinModules.home-manager
              ragenix.nixosModules.age
            ];
          };
        };
        "system/modules" = {
          functor = {
            enable = true;
          };
        };
        "nixos/modules" = {
          functor = {
            enable = true;
            external =
              [
                nix-index-database.nixosModules.nix-index
                home-manager.nixosModules.home-manager
                ragenix.nixosModules.age
              ]
              ++ (with (import (arcexprs + "/modules")).nixos; [
                base16
                base16-shared
              ]);
          };
        };
        "home/modules" = {
          functor = {
            enable = true;
            external =
              [
                nix-index-database.hmModules.nix-index
              ]
              ++ (with (import (arcexprs + "/modules")).home-manager; [
                base16
                base16-shared
              ]);
          };
        };
      };
    })
    .impure;
  inherit (inputs.nixpkgs) lib;
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
        home.system
      ];
      builder =
        {
          nixos = nixpkgs.lib.nixosSystem;
          darwin = darwin.lib.darwinSystem;
          macos = darwin.lib.darwinSystem;
        }
        .${toLower config.type};
      specialArgs = {inherit machine;} // defaultSpecialArgs;
    };
  };
  hostConfigs = mapAttrs (name: path:
    evalModules {
      modules = [
        hostModule
        path
      ];
      specialArgs =
        {
          machine = name;
        }
        // defaultSpecialArgs;
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
          modules = [scalpel.nixosModule];
          specialArgs = {
            prev = hostConfig;
          };
        }
      else hostConfig;
  };
in
  recursiveMergeAttrs (mapAttrsToList processHost hostConfigs)
  // {
    inherit inputs tree hostConfigs;
  }
  // (utils.lib.eachDefaultSystem (system: {
    devShells = let
      shells = mapAttrs (_: path:
        import path rec {
          inherit tree inputs system;
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (nixpkgs) lib;
        })
      tree.shells;
    in shells // { default = shells.repo; };
  }))
