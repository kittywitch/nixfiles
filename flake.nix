{
  description = "Kat's Infrastructure";
  inputs = {
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };
    dns = {
      url = "github:kirelagin/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust = {
      url = "github:arcnmx/nixexprs-rust";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nur.follows = "nur";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    # to allow non-nix 2.4 evaluation
    flake-compat = {
      url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
      type = "tarball";
      flake = false;
    };
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs = {
        systems.follows = "systems";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    kusachi = {
      url = "github:kittywitch/kusachi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae-rbw = {
      url = "github:kittywitch/vicinae-rbw";
      flake = false;
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs = {
        systems.follows = "systems";
        nixpkgs.follows = "nixpkgs";
        vicinae.follows = "vicinae";
      };
    };
    # better than nixpkgs.lib
    nix-std = {
      url = "github:chessai/nix-std";
    };
    ida-pro-overlay = {
      url = "github:kittywitch/ida-pro-overlay";
      #url = "path:/home/kat/src/ida-pro-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        #nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    # used for overriding unwanted flake inputs
    empty.url = "github:input-output-hk/empty-flake";
    # self-explanatory
    nixpkgs = {
      #follows = "chaotic/nixpkgs"; # TODO: replace follows
      url = "github:nixos/nixpkgs/nixos-unstable";
      #inputs.nixpkgs.follows = "chaotic/nixpkgs";
    };
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    proton-cachyos = {
      url = "github:powerofthe69/proton-cachyos-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mpv-websocket = {
      url = "github:kuroahna/mpv_websocket";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        rust-overlay.follows = "rust-overlay";
      };
    };
    continuwuity = {
      url = "github:continuwuity/continuwuity/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
      };
    };
    dolphin-overlay = {
      url = "github:rumboon/dolphin-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    infrastructure = {
      url = "github:gensokyo-zone/infrastructure/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-2405.follows = "empty";
        arcexprs.follows = "arcexprs";
        flakelib.follows = "flakelib";
        sops-nix.follows = "sops-nix";
        home-manager.follows = "home-manager";
        flake-utils.follows = "empty";
        website.follows = "empty";
        ci.follows = "empty";
        systemd2mqtt.follows = "empty";
        deploy-rs.follows = "empty";
        flake-compat.follows = "empty";
        barcodebuddy.follows = "empty";
        tree.follows = "tree";
      };
    };
    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs = {
        flake-utils.follows = "flake-utils";
      };
    };
    solaar = {
      url = "github:Svenum/Solaar-flake";
      # ewww flakehub ;;
      #url = "https://flakehub.com/f/Svenum/Solaar-flake/0.1.2.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils-plus";
      };
    };
    ucodenix.url = "github:e-tho/ucodenix";
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        rust-overlay.follows = "rust-overlay";
      };
    };
    ci = {
      url = "github:arcnmx/ci/v0.7";
      flake = false;
    };
    std = {
      url = "github:flakelib/std";
      inputs.nix-std.follows = "nix-std";
    };
    flakelib = {
      url = "github:flakelib/fl";
      inputs.std.follows = "std";
    };
    colmena.url = "github:zhaofengli/colmena";
    # self-explanatory
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    # file structure -> attrset
    tree = {
      url = "github:kittywitch/tree";
      inputs = {
        nix-std.follows = "nix-std";
        std.follows = "std";
        nixpkgs.follows = "nixpkgs";
      };
    };
    # konawall-py
    konawall-py = {
      url = "github:kittywitch/konawall-py";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    # hardware quirks
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    # pre-computed nix-index
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mewtris = {
      url = "github:kittywitch/mewtris/main";
      #url = "path:/home/kat/src/mewtris";
      inputs = {
        nix-std.follows = "nix-std";
        flake-compat.follows = "flake-compat";
      };
    };
    # a bunch of modules (also arcnmx is good)
    arcexprs = {
      #url = "github:kittywitch/arcexprs/master";
      url = "github:arcnmx/nixexprs/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        flake-parts.follows = "flake-parts";
      };
    };
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: import ./outputs.nix {inherit inputs;};
}
