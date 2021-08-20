{ config, lib, pkgs, sources, ... }:

let
  emacs = pkgs.callPackage sources.nix-doom-emacs {
    doomPrivateDir = "${./doom.d}";
    emacsPackages = pkgs.emacsPackagesFor pkgs.emacsPgtkGcc;
    bundledPackages = false;
    emacsPackagesOverlay = self: super: {
      magit-delta = super.magit-delta.overrideAttrs (esuper: {
        buildInputs = esuper.buildInputs ++ [ pkgs.git ];
      });
    };
  };
in {
  home.packages = [ emacs pkgs.sqlite ];

  home.file.".emacs.d/init.el".text = ''
    (load "default.el")
    (load-theme 'base16-${lib.elemAt (lib.splitString "." config.base16.alias.default) 1} t)
  '';
}

/*{
programs.doom-emacs = {
enable = true;
doomPrivateDir = ./doom.d;
extraConfig = ''
(load-theme 'base16-${lib.elemAt (lib.splitString "." config.base16.alias.default) 1} t)
'';
emacsPackage = pkgs.emacsPgtkGcc;
emacsPackagesOverlay = self: super: {
magit-delta = super.magit-delta.overrideAttrs (esuper: {
buildInputs = esuper.buildInputs ++ [ pkgs.git ];
});
};
};
}*/
