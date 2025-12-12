{ config, ... }: {
  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom.d;
    doomLocalDir = "${config.home.homeDirectory}/.local/share/nix-doom";
    extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
  };
}
