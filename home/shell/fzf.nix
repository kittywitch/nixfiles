{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.lists) optional;
in {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh.plugins = optional (pkgs.hostPlatform == pkgs.buildPlatform) {
    name = "fzf-tab";
    src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
  };
}
