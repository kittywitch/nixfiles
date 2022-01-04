{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio-pipewire;
    plugins = [ pkgs.obs-studio-plugins.wlrobs ];
  };
}
