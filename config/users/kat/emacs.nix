{ config, lib, pkgs, ... }:
let
  sources = import ../../../nix/sources.nix;
  emacs = pkgs.callPackage sources.nix-doom-emacs {
    doomPrivateDir = "${./doom.d}";
    emacsPackagesOverlay = self: super: {
      magit-delta = super.magit-delta.overrideAttrs (esuper: {
        buildInputs = esuper.buildInputs ++ [ pkgs.git ];
      });
    };
  };
in {
  users.users.kat.packages = [ emacs ];
  home-manager.users.kat = {
    home.file.".emacs.d/init.el".text = ''
      (load "default.el")
    '';
  };
}
