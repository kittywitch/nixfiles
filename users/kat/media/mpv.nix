{ config, lib, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.sponsorblock pkgs.mpvScripts.paused ];
    bindings =
      let
        vim = {
          "l" = "seek 5";
          "h" = "seek -5";
          "k" = "seek 60";
          "j" = "seek -60";
          "Ctrl+l" = "seek 1 exact";
          "Ctrl+h" = "seek -1 exact";
          "Ctrl+L" = "sub-seek 1";
          "Ctrl+H" = "sub-seek -1";
          "Ctrl+k" = "add chapter 1";
          "Ctrl+j" = "add chapter -1";
          "Ctrl+K" = "playlist-next";
          "Ctrl+J" = "playlist-prev";
          "Alt+h" = "frame-back-step";
          "Alt+l" = "frame-step";
          "`" = "cycle mute";
          "MBTN_RIGHT" = "cycle pause";
          "w" = "screenshot";
          "W" = "screenshot video";
          "Ctrl+w" = "screenshot window";
          "Ctrl+W" = "screenshot each-frame";
          "o" = "show-progress";
          "O" = "script-message show_osc_dur 5";
          "F1" = "cycle sub";
          "F2" = "cycle audio";
          "Ctrl+p" = "cycle video";
          "L" = "add volume 2";
          "H" = "add volume -2";
          "Alt+H" = "add audio-delay -0.100";
          "Alt+L" = "add audio-delay 0.100";
          "1" = "set volume 10";
          "2" = "set volume 20";
          "3" = "set volume 30";
          "4" = "set volume 40";
          "5" = "set volume 50";
          "6" = "set volume 60";
          "7" = "set volume 70";
          "8" = "set volume 80";
          "9" = "set volume 90";
          ")" = "set volume 150";
          "0" = "set volume 100";
          "m" = "cycle mute";
          "Ctrl+r" = "loadfile \${path}";
          "Ctrl+R" = "video-reload";
          "d" = "drop-buffers";
          "Ctrl+d" = "quit";
        }; 
        other = {
          "RIGHT" = vim."l";
          "LEFT" = vim."h";
          "UP" = vim."k";
          "DOWN" = vim."j";
          "Ctrl+0" = "set speed 1.0";
          "Ctrl+=" = "multiply speed 1.1";
          "Ctrl+-" = "multiply speed 1/1.1";
          "Shift+LEFT" = vim."H";
          "Shift+RIGHT" = vim."L";
          "Ctrl+RIGHT" = vim."Ctrl+l";
          "Ctrl+LEFT" = vim."Ctrl+h";
          "Ctrl+Shift+LEFT" = vim."Ctrl+H";
          "Ctrl+Shift+RIGHT" = vim."Ctrl+L";
          "Ctrl+UP" = vim."Ctrl+k";
          "Ctrl+DOWN" = vim."Ctrl+j";
          "Ctrl+Shift+UP" = vim."Ctrl+K";
          "Ctrl+Shift+DOWN" = vim."Ctrl+J";
          "Alt+LEFT" = vim."Alt+h";
          "Alt+RIGHT" = vim."Alt+l";
          "SPACE" = vim."MBTN_RIGHT";
          "m" = vim."`";
          "WHEEL_UP" = vim."L";
          "WHEEL_DOWN" = vim."H";
        }; in vim // other;
        config = {
          no-input-default-bindings = "";
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
    }
