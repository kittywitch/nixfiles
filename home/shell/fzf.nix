{ config, pkgs, lib, ... }: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh.plugins = lib.optional (pkgs.hostPlatform == pkgs.buildPlatform) ({
    name = "fzf-tab";
    src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
  });
}
