{ config, pkgs, ... }: {
  programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects-develop;
      args = {
        screenshots = true;
        daemonize = true;
        show-failed-attempts = true;
        indicator = true;
        indicator-radius = 110;
        indicator-thickness = 8;
        font = "Iosevka";
        font-size = "12px";
        clock = true;
        datestr = "%F";
        timestr = "%T";
        effect-blur = "5x2";
        fade-in = 0.2;
      };
      colors = with config.base16.palette; {
        key-hl = base0C;
        separator = base01;
        line = base01;
        line-clear = base01;
        line-caps-lock = base01;
        line-ver = base01;
        line-wrong = base01;
        ring = base00;
        ring-clear = base0B;
        ring-caps-lock = base09;
        ring-ver = base0D;
        ring-wrong = base08;
        inside = base00;
        inside-clear = base00;
        inside-caps-lock = base00;
        inside-ver = base00;
        inside-wrong = base00;
        text = base05;
        text-clear = base05;
        text-caps-lock = base05;
        text-ver = base05;
        text-wrong = base05;
      };
    };
  }
