{ nixpkgs, darwin, ... }@inputs: let
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
    };
  }).impure;
  lib = inputs.nixpkgs.lib;
  inherit (lib.attrsets) mapAttrs;
in {
  inherit tree;
  nixosConfigurations = mapAttrs (_: path: nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs tree;
      machine = name;
    };
    system = "x86_64-linux";
    modules = [
      path
    ];
    } ) tree.nixos.systems;
  darwinConfigurations = mapAttrs (_: path: darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs tree;
      machine = name;
    };
    system = "aarch64-darwin";
    modules = [
      path
    ];
    } ) tree.darwin.systems;
}
