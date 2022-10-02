{ inputs, system, ... }: let
  pkgs = import ./overlays { inherit inputs system; }; # A local import of nixpkgs without patching.
in inputs /*// {
    nixpkgs = pkgs.applyPatches {
      name = "nixpkgs";
      src = inputs.nixpkgs;
      patches = [
      ];
    };
  }*/ // { darwin = pkgs.applyPatches {
    # TODO: close when emi's PR is merged
    name = "darwin";
    src = inputs.darwin;
    patches = [ (pkgs.fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/LnL7/nix-darwin/pull/310.patch";
      sha256 = "sha256-drnLOhF8JGXx8YY7w1PD2arUZvbqafWPTatQNTHt+QI=";
    }) ];
  }; }

