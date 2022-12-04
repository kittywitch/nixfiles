{ self, utils, nixpkgs, darwin, home-manager, ragenix, scalpel, mach-nix, arcexprs, ... }@inputs: let
  tree = (inputs.tree.tree {
    inherit inputs;
    folder = ./.;
    config = {
      "/" = {
        excludes = [
          "flake"
          "default"
        ];
      };
      "system/modules" = {
        functor = {
          enable = true;
        };
      };
      "nixos/modules" = {
        functor = {
          enable = true;
          external = with (import (arcexprs + "/modules")).nixos; [
            base16
            base16-shared
          ];
        };
      };
      "home/modules" = {
        functor = {
          enable = true;
          external = with (import (arcexprs + "/modules")).home-manager; [
            base16
            base16-shared
          ];
        };
      };
    };
  }).impure;
  lib = inputs.nixpkgs.lib;
  inherit (lib.attrsets) mapAttrs;
in utils.lib.mkFlake {
  inherit self inputs;
  supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
  channelsConfig.allowUnfree = true;

  hostDefaults = {
    system = "x86_64-linux";
    modules = [
      tree.system.modules
    ];
    extraArgs = {
      inherit inputs tree;
    };
  };

  hosts = let
    outputForSystem = system: {
      "x86_64-linux" = "nixosConfigurations";
      "aarch64-darwin" = "darwinConfigurations";
    }.${system};
    builderForSystem = system: {
      "x86_64-linux" = nixpkgs.lib.nixosSystem;
      "aarch64-darwin" = darwin.lib.darwinSystem;
    }.${system};
    modulesForSystem = system: {
      "x86_64-linux" = [
        home-manager.nixosModules.home-manager
        ragenix.nixosModules.age
        tree.nixos.modules
      ];
      "aarch64-darwin" = [
        home-manager.darwinModules.home-manager
        ragenix.nixosModules.age
        tree.darwin.modules
      ];
    }.${system};
    mapSystem = system: name: path: {
      inherit system;
      output = outputForSystem system;
      builder = builderForSystem system;
      modules = (modulesForSystem system) ++ [
        path
      ];
      extraArgs = {
        machine = name;
      };
    };
  in mapAttrs (mapSystem "x86_64-linux") tree.nixos.systems
    // mapAttrs (mapSystem "aarch64-darwin") tree.darwin.systems;

  outputsBuilder = channels: {
    nixosConfigurations = mapAttrs(_: sys: sys.extendModules {
      modules = [ scalpel.nixosModule ];
      specialArgs = {
        prev = sys;
      };
    }) self.nixosConfigurations;

    homeManagerConfigurations = mapAttrs (name: path: home-manager.lib.homeManagerConfiguration {
      pkgs = channels.nixpkgs;
      extraSpecialArgs = {
        inherit channels inputs tree;
        machine = name;
        nixos = {};
      };
      modules = [
        tree.system.modules
        tree.home.common
        path
      ];
    }) tree.home.profiles;

    inherit tree;
  };

  devShells = {
    "python" = mach-nix.mkPythonShell {
      python = "python310";
      requirements = ''
      '';
    };
  };
}
