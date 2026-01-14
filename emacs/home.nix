{ config, pkgs, lib, ... }: let
  inherit (lib.meta) getExe';
  inherit (lib.modules) mkIf;
in {
  services.emacs = {
    #defaultEditor = true;
    enable = true;
    startWithUserSession = true;
    socketActivation.enable = true;
  };
  programs.git.settings.core.editor = mkIf config.services.emacs.defaultEditor "${getExe' config.services.emacs.package "emacsclient"} -c";
  programs.doom-emacs = {
    enable = true;
    emacs = pkgs.emacs-pgtk;
    doomDir = ./doom.d;
    doomLocalDir = "${config.home.homeDirectory}/.local/share/nix-doom";
    extraPackages = epkgs: with epkgs; [
      catppuccin-theme
      (treesit-grammars.with-grammars (ps: lib.filter (p: !p.meta.broken) (lib.attrValues ps)))
      rainbow-delimiters
      pkgs.ispell
      pkgs.clojure-lsp
      frames-only-mode
    ];
  };
}
