{ config ? { }, system ? builtins.currentSystem, ... }@args:

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs args;

  callPackage = pkgs.lib.callPackageWith (pkgs // newpkgs);

  newpkgs = {
    dino = callPackage "${sources.qyliss-nixlib}/overlays/patches/dino" {
      inherit (pkgs) dino;
    };

    matrix-appservice-irc = callPackage "${sources.arc-nixexprs}/pkgs/public/matrix" {};
    mx-puppet-discord = callPackage "${sources.arc-nixexprs}/pkgs/public/mx-puppet-discord" {};

    discord = pkgs.discord.override { nss = pkgs.nss_latest; };

    linuxPackagesFor = kernel:
      (pkgs.linuxPackagesFor kernel).extend (_: ksuper: {
        vendor-reset =
          (callPackage ./vendor-reset { kernel = ksuper.kernel; }).out;
      });

    colorhelpers = import ../lib/colorhelpers.nix { inherit (pkgs) lib; };

    inherit callPackage;
    appendOverlays = overlays: (pkgs.appendOverlays overlays) // newpkgs;
  };

in pkgs // newpkgs
