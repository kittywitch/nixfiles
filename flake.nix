{
  description = "Kat's Infrastructure";
  inputs = {
    systems.url = "github:nix-systems/default";
    catppuccin.url = "github:catppuccin/nix";
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

    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    nix-proton-cachyos.url = "github:kittywitch/nix-proton-cachyos";
    # used for overriding unwanted flake inputs
    empty.url = "github:input-output-hk/empty-flake";
    # self-explanatory
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
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
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    solaar = {
      # ewww flakehub ;;
      url = "https://flakehub.com/f/Svenum/Solaar-flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
        flake-compat.follows = "flake-compat";
      };
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    push2talk = {
      url = "github:cyrinux/push2talk/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
      };
    };
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
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
        utils.follows = "utils";
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
        flake-utils.follows = "utils";
      };
    };
    # WSL host
    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
        flake-compat.follows = "flake-compat";
      };
    };
    utils = {
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
        flake-utils.follows = "utils";
      };
    };
    # hardware quirks
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
    # secrets templating
    scalpel = {
      url = "github:kittywitch/scalpel";
      inputs = {
        flake-utils.follows = "utils";
        nixpkgs.follows = "nixpkgs";
        sops-nix.follows = "sops-nix";
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
        flake-utils.follows = "utils";
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
