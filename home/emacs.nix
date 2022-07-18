{ config, pkgs, lib, ... }: let
  inherit (lib.strings) splitString;
  inherit (lib.lists) elemAt;
in {
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackagesOverlay = self: super: {
      magit-delta = super.magit-delta.overrideAttrs (esuper: {
        buildInputs = esuper.buildInputs ++ [ pkgs.git ];
      });
    };
  };
}
