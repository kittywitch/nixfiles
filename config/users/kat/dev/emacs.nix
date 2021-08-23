{ config, lib, pkgs, sources, ... }:

let
  doom-emacs = pkgs.callPackage sources.nix-doom-emacs {
    doomPrivateDir = "${./doom.d}";
    emacsPackages = pkgs.emacsPackagesFor pkgs.emacsPgtkGcc;
    bundledPackages = false;
    emacsPackagesOverlay = self: super: {
      magit-delta = super.magit-delta.overrideAttrs (esuper: {
        buildInputs = esuper.buildInputs ++ [ pkgs.git ];
      });
      straight = self.straightBuild {
        pname = "straight";
      };
    };
  };
in
{
  home.packages = [ doom-emacs pkgs.sqlite ];

  home.file.".emacs.d/init.el".text = ''
    (load "default.el")
    (load-theme 'base16-${lib.elemAt (lib.splitString "." config.base16.alias.default) 1} t)
  '';
}
