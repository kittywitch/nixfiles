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
          infrastructure.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          solaar.nixosModules.default
          chaotic.nixosModules.default
          nixpkgs-xr.nixosModules.nixpkgs-xr
          spicetify-nix.nixosModules.spicetify
          nix-gaming.nixosModules.ntsync
          nix-gaming.nixosModules.pipewireLowLatency
          nix-gaming.nixosModules.platformOptimizations
          clipboard-sync.nixosModules.default
          niri.nixosModules.niri
          lix-module.nixosModules.default
          nixos-cli.nixosModules.nixos-cli
          nix-flatpak.nixosModules.nix-flatpak
          stylix.nixosModules.stylix
          microvm.nixosModules.host
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
            nix-index-database.homeModules.nix-index
            sops-nix.homeManagerModules.sops
            chaotic.homeManagerModules.default
            spicetify-nix.homeManagerModules.spicetify
            nix-flatpak.homeManagerModules.nix-flatpak
            zen-browser.homeModules.default
            stylix.homeModules.stylix
          ]
          ++ (with (import (inputs.arcexprs + "/modules")).home-manager; [
            i3gopher
            weechat
            syncplay
          ]);
      };
    };
  };
})
.impure
