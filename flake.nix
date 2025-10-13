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
    microvm = {
      url = "github:microvm-nix/microvm.nix/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
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
      flake = false;
    };
    rbw-bitw = {
      url = "github:arcnmx/rbw/bitw-v1.12.x";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flakelib.follows = "flakelib";
        rust.follows = "rust";
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
      follows = "chaotic/nixpkgs";
      #url = "github:nixos/nixpkgs/nixos-unstable";
      #inputs.nixpkgs.follows = "chaotic/nixpkgs";
    };
    clipboard-sync = {
      url = "github:dnut/clipboard-sync";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
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
    nixos-cli = {
      type = "github";
      owner = "nix-community";
      repo = "nixos-cli";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        nix-options-doc.follows = "empty";
      };
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs = {
        #nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        home-manager.follows = "home-manager";
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
        flake-compat.follows = "flake-compat";
        snowfall-lib.follows = "snowfall-lib";
      };
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils-plus.follows = "flake-utils-plus";
        flake-compat.follows = "flake-compat";
      };
    };
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
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
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        systems.follows = "systems";
        nixpkgs.follows = "nixpkgs";
      };
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
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
    # deployments
    deploy-rs = {
      url = "github:serokell/deploy-rs/master";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
    colmena.url = "github:zhaofengli/colmena";
    # self-explanatory
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    # self-explanatory
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    neorg-overlay = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        norg.follows = "norg";
        norg-meta.follows = "norg-meta";
      };
    };
    norg = {
      url = "github:kittywitch/tree-sitter-norg/dev";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
    norg-meta = {
      url = "github:kittywitch/tree-sitter-norg-meta";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
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
    minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/main";
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
    };
    base16 = {
      url = "github:arcnmx/base16.nix/flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flakelib.follows = "flakelib";
      };
    };
    base16-data = {
      url = "github:arcnmx/base16.nix/data";
      inputs = {
        base16.follows = "base16";
        nixpkgs.follows = "nixpkgs";
        flakelib.follows = "flakelib";
      };
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };
  outputs = inputs: import ./outputs.nix {inherit inputs;};
}
