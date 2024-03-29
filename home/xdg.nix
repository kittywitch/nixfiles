{ config, lib, pkgs,  ... }:

{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      pictures = "$HOME/media";
      videos = "$HOME/media/videos";
      documents = "$HOME/docs";
      download = "$HOME/downloads";
      desktop = "$HOME/tmp";
      templates = "$HOME/tmp";
      publicShare = "$HOME/shared";
      music = "$HOME/media/music";
    };
  };
}
