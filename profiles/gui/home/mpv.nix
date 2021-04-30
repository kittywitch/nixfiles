{ config, lib, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-wlrobs ];
  };

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
      osd-scale-by-window = false;
      osd-bar-h = 2.5; # 3.125 default
      osd-border-size = 2; # font border pixels, default 3
      term-osd-bar = true;
      script-opts = lib.concatStringsSep ","
        (lib.mapAttrsToList (k: v: "${k}=${toString v}") {
          osc-layout = "slimbox";
          osc-vidscale = "no";
          osc-deadzonesize = 0.75;
          osc-minmousemove = 4;
          osc-hidetimeout = 2000;
          osc-valign = 0.9;
          osc-timems = "yes";
          osc-seekbarstyle = "knob";
          osc-seekbarkeyframes = "no";
          osc-seekrangestyle = "slider";
        });
    };
  };

  programs.syncplay = {
    enable = true;
    username = "kat";
    defaultRoom = "lounge";
    server = { host = "sync.kittywit.ch"; };
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
