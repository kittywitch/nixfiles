{ nixpkgs, darwin, home-manager, ragenix, scalpel, ... }@inputs: let
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
in {
  inherit tree;
  nixosConfigurations = let base = mapAttrs (name: path: nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs tree;
      machine = name;
    };
    system = "x86_64-linux";
    modules = [
      home-manager.nixosModules.home-manager
      ragenix.nixosModule
      path
    ];
    } ) tree.nixos.systems in mapAttrs (_: sys: sys.extendModules {
      modules = [ scalpel.nixosModule ];
      specialArgs = {
        prev = sys;
      };
    } ) base;
  darwinConfigurations = mapAttrs (name: path: darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs tree;
      machine = name;
    };
    system = "aarch64-darwin";
    modules = [
      home-manager.nixosModules.home-manager
      path
    ];
    } ) tree.darwin.systems;
    homeManagerConfigurations = mapAttrs (name: path: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        inherit inputs tree;
        machine = name;
      };
      modules = [
        tree.home.common
        path
      ];
    }) tree.home;
}
