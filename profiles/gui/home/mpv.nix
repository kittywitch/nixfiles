{ config, lib, pkgs, witch, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.sponsorblock ];
    config = {
      profile = "gpu-hq";
      gpu-context = "wayland";
      vo = "gpu";
      volume-max = 200;
      keep-open = true;
      opengl-waitvsync = true;
      hwdec = "auto";
      demuxer-max-bytes = "2000MiB";
      demuxer-max-back-bytes = "250MiB";
    };
  };

  programs.syncplay = {
    enable = false;
    username = "kat";
    defaultRoom = "lounge";
    server = {
      host = "sync.kittywit.ch";
      password = witch.secrets.hosts.athame.syncplay.password;
    };
    # gui = false;
    trustedDomains = [ "youtube.com" "youtu.be" "twitch.tv" "soundcloud.com" ];
    config = {
      client_settings = {
        autoplayrequiresamefiles = false;
        readyatstart = true;
        pauseonleave = false;
        rewindondesync = false;
        rewindthreshold = 6.0;
        fastforwardthreshold = 6.0;
        unpauseaction = "Always";
      };
      gui = {
        #autosavejoinstolist = false;
        showdurationnotification = false;
        chatoutputrelativefontsize = config.lib.gui.fontSize 13.0;
      };
    };
  };
}
