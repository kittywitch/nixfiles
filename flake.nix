{
  description = "kat's nixfiles";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    arcexprs = {
      url = "github:arcnmx/nixexprs/master";
      flake = false;
    };
    ci = {
      url = "github:arcnmx/ci/nix2.4";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence/master";
    katexprs = {
      url = "github:kittywitch/nixexprs/main";
      flake = false;
    };
    anicca = {
      url = "github:kittywitch/anicca/main";
      flake = false;
    };
    nix-dns = {
      url = "github:kirelagin/nix-dns/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    nur.url = "github:nix-community/nur/master";
    nix-doom-emacs = {
      url = "github:vlaci/nix-doom-emacs/develop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tf-nix = {
      url = "github:arcnmx/tf-nix/master";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    trusted = {
      url = "path:./empty/.";
      flake = false;
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          devShell = import ./devShell.nix { inherit inputs system; };
          legacyPackages = import ./outputs.nix { inherit inputs system; };
        }
      );
}
