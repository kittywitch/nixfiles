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

    "nixvim".functor.enable = true;
    "nixvim/*".functor.enable = true;
    "nixvim/plugins/*".functor.enable = true;

    "home/*".functor.enable = true;
    "home/profiles/*".functor.enable = true;
    "home/profiles/nixvim".functor.excludes = [
      "plugins"
    ];
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
          simple-nixos-mailserver.nixosModules.default
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          infrastructure.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          solaar.nixosModules.default
          #nixpkgs-xr.nixosModules.nixpkgs-xr
          spicetify-nix.nixosModules.spicetify
          clipboard-sync.nixosModules.default
          stylix.nixosModules.stylix
          mewtris.nixosModules.mewtris
          noctalia.nixosModules.default
          ucodenix.nixosModules.default
          inputs.mango.nixosModules.mango
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
            nix-doom-emacs-unstraightened.hmModule
            nix-index-database.homeModules.nix-index
            sops-nix.homeManagerModules.sops
            spicetify-nix.homeManagerModules.spicetify
            stylix.homeModules.stylix
            noctalia.homeModules.default
            nixvim.homeModules.nixvim
            nixcord.homeModules.nixcord
            inputs.mango.hmModules.mango
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
