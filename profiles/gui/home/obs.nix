{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-wlrobs ];
  };

  programs.zsh.shellAliases = { obs = "env QT_QPA_PLATFORM=xcb obs"; };
}
