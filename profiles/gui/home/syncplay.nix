{ config, ... }:

{
 
  programs.syncplay = {
    enable = true;
    username = "kat";
    defaultRoom = "lounge";
    server = { host = "sync.kittywit.ch"; };
    playerArgs = [ "--ytdl-format=bestvideo[height<=1080]+bestaudio/best[height<=1080]/bestvideo+bestaudio/best" ];
    # gui = false;
    config = {
      client_settings = {
        onlyswitchtotrusteddomains = false;
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
      };
    };
  };
}
