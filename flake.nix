{
  description = "kat's personal system flakes";
  inputs = {
    empty.url = "github:input-output-hk/empty-flake";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    tree = {
      url = "github:kittywitch/tree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
      };
    };
    scalpel = {
      url = "github:polygon/scalpel";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # i get that you have to test shit, but isn't throwing sops-nix and thus three
        # whole fucking versions of nixpkgs into shit a little excessive?
        # fuck the sops-nix people to begin with :/
        sops-nix.follows = "empty";
      };
    };
    mach-nix = {
      url = "mach-nix/3.5.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
      };
    };
    arcexprs = {
      url = "github:arcnmx/nixexprs/master";
      flake = false;
    };
  };
  outputs = { ... }@inputs: import ./default.nix inputs;
}
