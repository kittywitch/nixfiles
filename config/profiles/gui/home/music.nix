{ config, lib, pkgs, witch, ... }:

{
  config = lib.mkIf config.deploy.profile.gui {
    programs.ncmpcpp = {
      enable = true;
      mpdMusicDir = "/home/kat/music";
    };
    programs.beets = {
      enable = true;
      package = pkgs.unstable.beets;
      settings = {
        directory = "~/music";
        library = "~/.local/share/beets.db";
        plugins = lib.concatStringsSep " " [
          "mpdstats"
          "mpdupdate"
          "duplicates"
          "chroma"
        ];
      };
    };
    services.mpd = {
      enable = true;
      network.startWhenNeeded = true;
      musicDirectory = "/home/kat/music";
      extraConfig = ''
        audio_output {
          type "pulse"
          name "speaker"
        }
      '';
    };
  };
}
