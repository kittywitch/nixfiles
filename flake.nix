{
  description = "Kat's Infrastructure";
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust.url = "github:arcnmx/nixexprs-rust";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    # TODO: https://github.com/catppuccin/nix/issues/601
    catppuccin.url = "github:catppuccin/nix"; #/194881dd2ad6303bc2d49f9ce484d127372d7465";
    flake-parts.url = "github:hercules-ci/flake-parts";
    # to allow non-nix 2.4 evaluation
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    rbw-bitw.url = "github:arcnmx/rbw/bitw-v1.12.x";
    # better than nixpkgs.lib
    std = {
      url = "github:chessai/nix-std";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";

    # used for overriding unwanted flake inputs
    empty.url = "github:input-output-hk/empty-flake";
    # self-explanatory
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    clipboard-sync.url = "github:dnut/clipboard-sync";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    infrastructure = {
      url = "github:gensokyo-zone/infrastructure/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        arcexprs.follows = "arcexprs";
        flakelib.follows = "flakelib";
        sops-nix.follows = "sops-nix";
        home-manager.follows = "home-manager";
        flake-utils.follows = "empty";
        website.follows = "empty";
        ci.follows = "empty";
        deploy-rs.follows = "empty";
        flake-compat.follows = "empty";
        barcodebuddy.follows = "empty";
      };
    };
    nixos-cli = {
      type = "github";
      owner = "nix-community";
      repo = "nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    solaar = {
      # ewww flakehub ;;
      url = "https://flakehub.com/f/Svenum/Solaar-flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
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
    moonlight = {
      url = "github:moonlight-mod/moonlight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    catppuccin-qtct = {
      type = "github";
      owner = "catppuccin";
      repo = "qt5ct";
      flake = false;
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    push2talk = {
      url = "github:cyrinux/push2talk/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    ci = {
      url = "github:arcnmx/ci/v0.7";
      flake = false;
    };
    flakelibstd = {
      url = "github:flakelib/std";
      inputs.nix-std.follows = "std";
    };
    flakelib = {
      url = "github:flakelib/fl";
      inputs.std.follows = "flakelibstd";
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
    # status bar
    spacebar = {
      url = "github:cmacrae/spacebar/v1.4.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    # file structure -> attrset
    tree = {
      url = "github:kittywitch/tree";
      inputs = {
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
    # a bunch of modules (also arcnmx is good)
    arcexprs = {
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
    # plasma manager
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nur.url = "github:nix-community/NUR";
  };
  outputs = inputs: import ./outputs.nix {inherit inputs;};
}
