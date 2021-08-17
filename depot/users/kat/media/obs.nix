{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio-pipewire;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
  };

  programs.zsh.shellAliases = { obs = "env QT_QPA_PLATFORM=xcb obs"; };
}
