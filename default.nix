{ self, utils, nixpkgs, darwin, home-manager, ragenix, scalpel, mach-nix, ... }@inputs: let
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
      "home/*" = {
        functor.enable = true;
      };
    };
  }).impure;
  lib = inputs.nixpkgs.lib;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.lists) singleton;
in utils.lib.mkFlake {
  inherit self inputs;
  supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
  channelsConfig.allowUnfree = true;

  hostDefaults = {
    system = "x86_64-linux";
    modules = [
      home-manager.nixosModules.home-manager
      ragenix.nixosModules.age
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
    mapSystem = system: name: path: {
      inherit system;
      output = outputForSystem system;
      builder = builderForSystem system;
      modules = singleton path;
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
        inherit inputs tree;
        machine = name;
      };
      modules = [
        tree.home.common
        path
      ];
    }) tree.home;

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
