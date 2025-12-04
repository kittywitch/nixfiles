{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;
in {
  home.packages = with pkgs; [
    wl-clipboard
    pamixer
    wlr-randr
    wl-screenrec
    slurp
    grim
    pavucontrol
    brightnessctl
    nautilus
    playerctl
    glib
    pcmanfm
  ];
  stylix.targets.niri.enable = true;
  programs.niri = {
    settings = {
      cursor = {
        inherit (config.home.pointerCursor) size;
        theme = config.home.pointerCursor.name;
      };
      gestures.hot-corners.enable = false;
      input = {
        workspace-auto-back-and-forth = true;
        keyboard = {
          xkb = {
            options = "compose:rctrl,ctrl:nocaps";
          };
        };
        mouse = {
          accel-profile = "flat";
        };
        touchpad = {
          dwt = true;
          dwtp = true;
        };
        # i think this causes issues with games
        #focus-follows-mouse.enable = true;
      };
      layout = {
        gaps = 10;
        always-center-single-column = true;
        preset-column-widths = [
          {proportion = 0.33333;}
          {proportion = 0.5;}
          {proportion = 0.66667;}
          {proportion = 1.0;}
        ];
        default-column-width = {
          proportion = 1.0;
        };
        border = {
          enable = true;
          width = 2;
        };
        focus-ring = {
          enable = false;
          width = 2;
        };
        shadow = {
          enable = true;
        };
      };
      debug = {
        #honor-xdg-activation-with-invalid-serial = {};
        #strict-new-window-focus-policy = {};
        #deactivate-unfocused-windows = {};
      };
      workspaces = {
        "01" = {
          name = "一";
        };
        "02" = {
          name = "二";
        };
        "03" = {
          name = "三";
        };
        "04" = {
          name = "四";
        };
        "05" = {
          name = "五";
        };
        "06" = {
          name = "六";
        };
        "07" = {
          name = "七";
        };
        "08" = {
          name = "八";
        };
        "09" = {
          name = "九";
        };
        "10" = {
          name = "十";
        };
      };
      environment = {
        MOZ_ENABLE_WAYLAND = "1";
        XDG_CURRENT_DESKTOP = "niri";
        GDK_BACKEND = "wayland";
        CLUTTER_BACKEND = "wayland";
      };
      xwayland-satellite = {
        enable = true;
        path = getExe pkgs.xwayland-satellite-unstable;
      };
      prefer-no-csd = true;
      clipboard.disable-primary = true;
      hotkey-overlay.skip-at-startup = true;
    };
  };
}
