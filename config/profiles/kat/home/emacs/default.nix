{ config, lib, pkgs, sources, ... }:
let
  emacs = pkgs.callPackage sources.nix-doom-emacs {
    doomPrivateDir = "${./doom.d}";
    emacsPackagesOverlay = self: super: {
      magit-delta = super.magit-delta.overrideAttrs
        (esuper: { buildInputs = esuper.buildInputs ++ [ pkgs.git ]; });
    };
  };
in {
  config = lib.mkIf config.deploy.profile.kat {
    home.sessionVariables.EDITOR = "emacs";
    home.packages = [ emacs ];
    home.file.".emacs.d/init.el".text = ''
      (load "default.el")
    '';
  };
}
