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

    common.functor.enable = true;

    "home/*".functor.enable = true;
    "home/profiles/*".functor.enable = true;
    "home/environments/*".functor.enable = true;
    "home/user".evaluateDefault = true;
    "home/user/data".evaluate = true;

    "nixos/*".functor.enable = true;
    "nixos/profiles/*".functor = {
      enable = true;
      excludes = [
        "scalpel"
      ];
    };
    "nixos/servers/*".functor = {
      enable = true;
      excludes = [
        "scalpel"
      ];
    };

    "darwin/*".functor.enable = true;

    "nixos/environments/*".functor.enable = true;

    "systems/*".aliasDefault = true;
    "packages/*".aliasDefault = true;

    # Various modules
    "modules/common" = {
      functor = {
        enable = true;
      };
    };
    "nixos/hardware" = {
      external = inputs.nixos-hardware.outputs.nixosModules;
    };
    "nixos/hardware/conditional" = {
      functor.enable = true;
    };
    "modules/system" = {
      functor = {
        enable = true;
      };
    };
    "modules/nixos" = {
      functor = {
        enable = true;
        external = with inputs; [
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          minecraft.nixosModules.minecraft-servers
          sops-nix.nixosModules.sops
          base16.nixosModules.base16
          lanzaboote.nixosModules.lanzaboote
        ];
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
            plasma-manager.homeManagerModules.plasma-manager
            base16.homeModules.base16
            inputs.sops-nix.homeManagerModules.sops
          ]
          ++ (with (import (inputs.arcexprs + "/modules")).home-manager; [
            i3gopher
            weechat
          ]);
      };
    };
  };
})
.impure
