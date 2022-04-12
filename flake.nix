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
    anicca = {
      url = "github:kittywitch/anicca/main";
      flake = false;
    };
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    home-manager-darwin.url = "github:nix-community/home-manager";
    home-manager-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
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

  outputs = { self, nixpkgs, flake-utils, darwin, home-manager-darwin, ... }@inputs: {	
    darwinConfigurations."sumireko" = let
	system = "aarch64-darwin";
	meta = self.legacyPackages.${system};
      in darwin.lib.darwinSystem {
      inherit inputs;
      inherit system;
      specialArgs = {
	inherit inputs meta;
	tf = { };
      };
      pkgs = self.legacyPackages.${system}.darwin-pkgs;
      modules = with meta; [
        home-manager-darwin.darwinModules.home-manager
        meta.hosts.sumireko
	];
    };
  }  // 
    (flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        rec {
          devShell = import ./devShell.nix { inherit inputs system; };
          legacyPackages = import ./outputs.nix { inherit inputs system; };
          nixosConfigurations = legacyPackages.network.nodes;
        }
      ));
}
