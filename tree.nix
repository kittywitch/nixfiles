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
    system.functor.enable = true;
    # Re-map home directory profiles
    home.evaluateDefault = true;
    # Allow profile importing
    "nixos/*".functor.enable = true;
    "darwin/*".functor.enable = true;
    "home/*".functor.enable = true;
    # Various modules
    "nixos/modules" = {
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
    "darwin/modules" = {
      functor = {
        enable = true;
        external = with inputs; [
          home-manager.darwinModules.home-manager
          ragenix.nixosModules.age
        ];
      };
    };
    "home/modules" = {
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
