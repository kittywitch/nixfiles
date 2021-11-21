{
  description = "kat's nixfiles";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    arcexprs = {
      url = "github:arcnmx/nixexprs/master";
      flake = false;
    };
    ci = {
      url = "github:arcnmx/ci/master";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager/master";
    impermanence.url = "github:nix-community/impermanence/master";
    katexprs = {
      url = "github:kittywitch/nixexprs/main";
      flake = false;
    };
    anicca = {
      url = "github:kittywitch/anicca/main";
      flake = false;
    };
    nix-dns.url = "github:kirelagin/nix-dns/master";
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    nur.url = "github:nix-community/nur/master";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs/develop";
    tf-nix = {
      url = "github:arcnmx/tf-nix/master";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    trusted = {
      url = "git+ssh://git@github.com/kittywitch/nixfiles-trusted?ref=main";
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
