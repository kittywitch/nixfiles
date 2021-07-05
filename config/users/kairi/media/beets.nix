{ config, pkgs, lib, ... }:

{
  programs.beets = {
    enable = true;
    package = pkgs.beets;
    settings = {
      directory = "~/media-share/music";
      library = "~/.local/share/beets.db";
      plugins = lib.concatStringsSep " " [
        "mpdstats"
        "mpdupdate"
        "duplicates"
        "chroma"
      ];
    };
  };
}
