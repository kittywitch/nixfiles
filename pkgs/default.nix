{ config ? { }, system ? builtins.currentSystem, ... }@args:

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs args;

  callPackage = pkgs.lib.callPackageWith (pkgs // newpkgs);

  newpkgs = {
    dino = callPackage "${sources.qyliss-nixlib}/overlays/patches/dino" {
      inherit (pkgs) dino;
    };

    linuxPackagesFor = kernel:
      (pkgs.linuxPackagesFor kernel).extend (_: ksuper: {
        vendor-reset =
          (callPackage ./vendor-reset { kernel = ksuper.kernel; }).out;
      });

    inherit callPackage;
    appendOverlays = overlays: (pkgs.appendOverlays overlays) // newpkgs;
  };

in pkgs // newpkgs
