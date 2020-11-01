{ nixpkgs ? <nixpkgs>, ... }:

let
  pkgs = import nixpkgs {};
  callPackage = pkgs.lib.callPackageWith (pkgs // newpkgs);

  newpkgs = {
  };

in newpkgs
