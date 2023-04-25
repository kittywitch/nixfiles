{
  inputs,
  pkgs,
  ...
}:
(inputs.tree.tree {
  inherit inputs;
  folder = ./.;
  config = {
    # Exclude things that would overlap with namespace things, potentially
    "/" = {
      excludes = [
        "flake"
        "default"
        "tree"
        "inputs"
        "outputs"
        "pkgs"
      ];
    };
    # Ignore the default.nix we actually use
    shells = {
      excludes = [
        "default"
      ];
    };
    systems = {
      excludes = [
        "default"
      ];
    };
    # Required for all-system common imports
    common.functor.enable = true;
    # Re-map home directory profiles
    kat.evaluateDefault = true;
    "kat/user".evaluateDefault = true;
    "kat/user/data".evaluate = true;
    # Allow profile importing
    "nixos/*".functor.enable = true;
    "nixos/roles/*".functor.enable = true;
    "nixos/hardware".evaluateDefault = true;
    "nixos/hardware/*".functor.enable = true;
    "darwin/*".functor.enable = true;
    "kat/*".functor.enable = true;
    # Various modules
    "modules/common" = {
      functor = {
        enable = true;
      };
    };
    "nixos/hardware" = {
      external = inputs.nixos-hardware.outputs.nixosModules;
    };
    "modules/nixos" = {
      functor = {
        enable = true;
        external = with inputs;
          [
            nix-index-database.nixosModules.nix-index
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
          ]
          ++ (with (import (inputs.arcexprs + "/modules")).nixos; [
            base16
            base16-shared
          ]);
      };
    };
    "modules/darwin" = {
      functor = {
        enable = true;
        external = with inputs; [
          home-manager.darwinModules.home-manager
        ];
      };
    };
    "modules/home" = {
      functor = {
        enable = true;
        external = with inputs;
          [
            nix-index-database.hmModules.nix-index
          ]
          ++ (with (import (inputs.arcexprs + "/modules")).home-manager; [
            base16
            i3gopher
            konawall
          ]);
      };
    };
  };
})
.impure
