{
  description = "Kat's Infrastructure";
  inputs = {
    # to allow non-nix 2.4 evaluation
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    # better than nixpkgs.lib
    std = {
      url = "github:chessai/nix-std";
    };
    # used for overriding unwanted flake inputs
    empty.url = "github:input-output-hk/empty-flake";
    # self-explanatory
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
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
    };
    # file structure -> attrset
    tree = {
      url = "github:kittywitch/tree";
      inputs.std.follows = "std";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # secrets templating
    scalpel = {
      url = "github:polygon/scalpel";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        sops-nix.follows = "sops-nix";
      };
    };
    # dependency database for mach-nix
    pypi-deps-db = {
      url = "github:DavHau/pypi-deps-db";
      flake = false;
    };
    # nixified python environments
    mach-nix = {
      url = "mach-nix/3.5.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
        pypi-deps-db.follows = "pypi-deps-db";
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
      flake = false;
    };
    base16 = {
      url = "github:arcnmx/base16.nix/flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    base16-data = {
      url = "github:arcnmx/base16.nix/data";
      inputs = {
        base16.follows = "base16";
        nixpkgs.follows = "nixpkgs";
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
  };
  outputs = inputs: import ./outputs.nix {inherit inputs;};
}
