{
  description = "kat's personal system flakes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    tree = {
      url = "github:kittywitch/tree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { ... }@inputs: import ./default.nix { inherit inputs; };
}
