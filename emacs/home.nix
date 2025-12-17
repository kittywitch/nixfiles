{ config, pkgs, ... }: {
  programs.doom-emacs = {
    enable = true;
    emacs = pkgs.emacs-pgtk;
    doomDir = ./doom.d;
    doomLocalDir = "${config.home.homeDirectory}/.local/share/nix-doom";
    extraPackages = epkgs: with epkgs; [
      catppuccin-theme
      treesit-grammars.with-all-grammars
      rainbow-delimiters
      pkgs.ispell
      pkgs.clojure-lsp
    ];
  };
}
