{inputs, ...}:
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
    "darwin/*".functor.enable = true;
    "kat/*".functor.enable = true;
    # Various modules
    "modules/nixos" = {
      functor = {
        enable = true;
        external = with inputs;
          [
            nix-index-database.nixosModules.nix-index
            home-manager.nixosModules.home-manager
            ragenix.nixosModules.age
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
          ragenix.nixosModules.age
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
          ]);
      };
    };
  };
})
.impure
