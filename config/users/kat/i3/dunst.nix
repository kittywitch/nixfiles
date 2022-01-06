{ config, base16, pkgs, lib, ... }: with lib; {
   services.dunst = {
      enable = true;
      iconTheme = {
        inherit (config.gtk.iconTheme) package name;
        size = mkDefault "32x32";
      };
      settings = with base16.map.hash.rgba; {
        global = {
          transparency = 10;
          follow = "mouse";
          font = "${config.kw.theme.font.name} 9";
          width = "(0, 720)"; # min, max
          idle_threshold = 60 * 3;
          show_age_threshold = 60;
          icon_position = "right";
          mouse_right_click = "do_action";
          mouse_middle_click = "context";
          mouse_left_click = "close_current";
          show_indicators = false;
          fullscreen = "pushback"; # default is to "show"
          #dmenu = "${config.programs.dmenu.package}/bin/dmenu";
          dmenu = "${config.programs.rofi.package}/bin/rofi";
          browser = "${pkgs.xdg-utils}/bin/xdg-open";
        };
        urgency_low = {
          frame_color = background_light;
          background = background_selection;
          foreground = foreground_alt;
          highlight = keyword;
          timeout = 10;
        };
        urgency_normal = {
          frame_color = background_light;
          background = background;
          foreground = foreground;
          highlight = keyword;
          timeout = 30;
        };
        urgency_critical = {
          frame_color = link; # or url
          background = background_light;
          foreground = foreground;
          highlight = keyword;
          timeout = 60;
        };
      };
    };
}
