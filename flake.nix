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
    rbw-bitw = {
      url = "github:arcnmx/rbw/bitw-v1.12.x";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flakelib.follows = "flakelib";
        rust.follows = "rust";
      };
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
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qml-niri = {
      url = "github:juuyokka/qml-niri/feat-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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
    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ucodenix.url = "github:e-tho/ucodenix";
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
    fzfdapter = {
      url = "github:kittywitch/fzfdapter";
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
    hyprland.url = "github:hyprwm/Hyprland/6712fb954f2e4f701878b97f19b7185a2cd0e192";
    hy3 = {
      #url = "github:outfoxxed/hy3?ref=33fb5c01f192c0b1b6c1ab29f4a38e4bdfc85427";
      url = "github:Immelancholy/hy3/update-to-m_reserved_area";
      inputs.hyprland.follows = "hyprland";
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
    nix-search-tv = {
      url = "github:3timeslazy/nix-search-tv";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        flake-parts.follows = "flake-parts";
      };
    };
    slimevr-wrangler-src = {
      url = "github:kittywitch/slimevr-wrangler/fix-mac-casing";
      flake = false;
    };
    slimevr-wrangler = {
      url = "github:kittywitch/slimevr-wrangler-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        slimevr-wrangler-src.follows = "slimevr-wrangler-src";
      };
    };
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: import ./outputs.nix {inherit inputs;};
}
