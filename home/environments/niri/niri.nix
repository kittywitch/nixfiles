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
        background-color = config.palette.base.hex;
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
          active.color = config.palette.surface0.hex;
          inactive.color = config.palette.surface0.hex;
          urgent.color = config.palette.red.hex;
        };
        focus-ring = {
          enable = false;
          width = 2;
          active.color = config.palette.${config.catppuccin.accent}.hex;
        };
        shadow = {
          enable = true;
          color = config.palette.crust.hex;
        };
      };
      debug = {
        wait-for-frame-completion-in-pipewire = {};
        deactivate-unfocused-windows = {};
      };
      workspaces = {
        browser = {};
        chat = {};
        vidya = {};
        media = {};
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
