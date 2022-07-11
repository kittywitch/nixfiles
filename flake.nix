{
  description = "kat's nixfiles";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    arcexprs = {
      url = "github:arcnmx/nixexprs/master";
      flake = false;
    };
    ci = {
      url = "github:arcnmx/ci/nix2.4";
      flake = false;
    };
    home-manager = {
      url = "github:kittywitch/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-dns = {
      url = "github:kirelagin/nix-dns/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    tf-nix = {
      url = "github:arcnmx/tf-nix/master";
      flake = false;
    };
    trusted = {
      url = "path:./flake/empty/.";
      flake = false;
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nur.url = "github:nix-community/nur/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: let
    providedSystems = flake-utils.lib.eachDefaultSystem
  (system:
  rec {
    devShells.default = import ./devShell.nix { inherit system inputs; };
    legacyPackages = import ./outputs.nix { inherit system inputs; };
  });
  in providedSystems // {
    nixosConfigurations = self.legacyPackages.x86_64-linux.network.nodes.nixos;
    darwinConfigurations = builtins.mapAttrs (_: config: {
      inherit (config.deploy) pkgs;
      inherit config;

      system = config.system.build.toplevel;
    }) self.legacyPackages.aarch64-darwin.network.nodes.darwin;
  };
}
