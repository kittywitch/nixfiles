{
  description = "kat's nixfiles";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    arcexprs = {
      url = "github:arcnmx/nixexprs/master";
      flake = false;
    };
    ci = {
      url = "github:arcnmx/ci/v0.6";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nur.url = "github:nix-community/nur/master";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systemd2mqtt = {
      url = "github:arcnmx/systemd2mqtt";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    providedSystems =
      flake-utils.lib.eachDefaultSystem
      (system: rec {
        devShells.default = import ./devShell.nix {inherit system inputs;};
        legacyPackages = import ./meta.nix {inherit system inputs;};
      });
  in
    providedSystems
    // {
      nixosConfigurations = builtins.mapAttrs (_: config:
        config
        // {
          inherit config;
        })
      self.legacyPackages.x86_64-linux.network.nodes;
    };
}
