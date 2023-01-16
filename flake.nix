{
  description = "the katzian monorepo effort";
  inputs = {
    # to allow non-nix 2.4 evaluation
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    # used for overriding unwanted flake inputs
    empty.url = "github:input-output-hk/empty-flake";
    # self-explanatory
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # self-explanatory
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # self-explanatory
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # flake-utils
    utils.url = "github:numtide/flake-utils";
    # file structure -> attrset
    tree = {
      url = "github:kittywitch/tree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # secrets
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
      };
    };
    # secrets templating
    scalpel = {
      url = "github:polygon/scalpel";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # i get that you have to test shit, but isn't throwing sops-nix and thus three
        # whole fucking versions of nixpkgs into shit a little excessive?
        # making people have to stub this out unless they want to deal with importing that is a pain
        sops-nix.follows = "empty";
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
    # a bunch of modules (also arcnmx is good)
    arcexprs = {
      url = "github:arcnmx/nixexprs/master";
      flake = false;
    };
  };
  outputs = inputs: import ./outputs.nix inputs;
}
