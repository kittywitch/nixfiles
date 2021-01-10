{ nixpkgs ? <nixpkgs>, self, super, ... }:

let
  pkgs = import nixpkgs { };
  callPackage = pkgs.lib.callPackageWith (pkgs // newpkgs);
  newpkgs = { 
    linuxPackagesFor = kernel: (super.linuxPackagesFor kernel).extend (_: ksuper: {
      vendor-reset = (callPackage ./vendor-reset {kernel = ksuper.kernel;}).out;
    });
  };
in newpkgs
