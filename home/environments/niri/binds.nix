{
  config,
  pkgs,
  lib,
  std,
  ...
}: let
  inherit (std) list;
  inherit (lib.modules) mkMerge;
in {
  programs.niri.settings.binds = let
    bindWorkspace = key: workspace: {
      "Mod+${key}".action.focus-workspace = workspace;
      "Mod+Ctrl+${key}".action.move-column-to-workspace = workspace;
    };
    workspaceBindings =
      list.map (v: bindWorkspace (builtins.toString v) v) (list.range 1 9)
      ++ [
        (
          bindWorkspace "0" 10
        )
      ];
  in
    mkMerge (workspaceBindings
      ++ [
        {
          # Transcribed: https://github.com/sodiboo/niri-flake/issues/483
          # thank you Pacman99 you chad :3
          "Mod+Q".action.close-window = {};
          "Mod+O".action.toggle-overview = {};

          "Mod+Left".action.focus-column-left = {};
          "Mod+Down".action.focus-window-down = {};
          "Mod+Up".action.focus-window-up = {};
          "Mod+Right".action.focus-column-right = {};
          "Mod+H".action.focus-column-left = {};
          "Mod+J".action.focus-window-down = {};
          "Mod+K".action.focus-window-up = {};
          "Mod+L".action.focus-column-right = {};

          "Mod+Ctrl+Left".action.move-column-left = {};
          "Mod+Ctrl+Down".action.move-window-down = {};
          "Mod+Ctrl+Up".action.move-window-up = {};
          "Mod+Ctrl+Right".action.move-column-right = {};
          "Mod+Ctrl+H".action.move-column-left = {};
          "Mod+Ctrl+J".action.move-window-down = {};
          "Mod+Ctrl+K".action.move-window-up = {};
          "Mod+Ctrl+L".action.move-column-right = {};

          "Mod+Home".action.focus-column-first = {};
          "Mod+End".action.focus-column-last = {};
          "Mod+Ctrl+Home".action.move-column-to-first = {};
          "Mod+Ctrl+End".action.move-column-to-last = {};

          "Mod+Shift+Left".action.focus-monitor-left = {};
          "Mod+Shift+Down".action.focus-monitor-down = {};
          "Mod+Shift+Up".action.focus-monitor-up = {};
          "Mod+Shift+Right".action.focus-monitor-right = {};
          "Mod+Shift+H".action.focus-monitor-left = {};
          "Mod+Shift+J".action.focus-monitor-down = {};
          "Mod+Shift+K".action.focus-monitor-up = {};
          "Mod+Shift+L".action.focus-monitor-right = {};

          "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = {};
          "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = {};
          "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = {};
          "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = {};
          "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = {};
          "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = {};
          "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = {};
          "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = {};

          "Mod+Page_Down".action.focus-workspace-down = {};
          "Mod+Page_Up".action.focus-workspace-up = {};
          "Mod+U".action.focus-workspace-down = {};
          "Mod+I".action.focus-workspace-up = {};
          "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
          "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
          "Mod+Ctrl+U".action.move-column-to-workspace-down = {};
          "Mod+Ctrl+I".action.move-column-to-workspace-up = {};

          "Mod+Shift+Page_Down".action.move-workspace-down = {};
          "Mod+Shift+Page_Up".action.move-workspace-up = {};
          "Mod+Shift+U".action.move-workspace-down = {};
          "Mod+Shift+I".action.move-workspace-up = {};

          "Mod+WheelScrollDown" = {
            cooldown-ms = 150;
            action.focus-workspace-down = {};
          };
          "Mod+WheelScrollUp" = {
            cooldown-ms = 150;
            action.focus-workspace-up = {};
          };
          "Mod+Ctrl+WheelScrollDown" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-down = {};
          };
          "Mod+Ctrl+WheelScrollUp" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-up = {};
          };

          "Mod+WheelScrollRight".action.focus-column-right = {};
          "Mod+WheelScrollLeft".action.focus-column-left = {};
          "Mod+Ctrl+WheelScrollRight".action.move-column-right = {};
          "Mod+Ctrl+WheelScrollLeft".action.move-column-left = {};

          "Mod+Shift+WheelScrollDown".action.focus-column-right = {};
          "Mod+Shift+WheelScrollUp".action.focus-column-left = {};
          "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = {};
          "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = {};

          "Mod+Comma".action.consume-window-into-column = {};
          "Mod+Period".action.expel-window-from-column = {};

          "Mod+R".action.switch-preset-column-width = {};
          "Mod+Shift+R".action.reset-window-height = {};
          "Mod+F".action.maximize-column = {};
          "Mod+Shift+F".action.fullscreen-window = {};
          "Mod+C".action.center-column = {};

          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";

          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          "Print".action.screenshot = {};
          "Ctrl+Print".action.screenshot-screen = {};
          "Alt+Print".action.screenshot-window = {};

          # The quit action will show a confirmation dialog to avoid accidental exits.
          "Mod+Shift+E".action.quit = {};

          # Powers off the monitors. To turn them back on, do any input like
          # moving the mouse or pressing any other key.
          "Mod+Shift+P".action.power-off-monitors = {};

          # Kat
          "XF86MonBrightnessUp".action.spawn = ["${config.services.avizo.package}/bin/lightctl" "up"];
          "XF86MonBrightnessDown".action.spawn = ["${config.services.avizo.package}/bin/lightctl" "down"];
          "XF86AudioRaiseVolume".action.spawn = ["${config.services.avizo.package}/bin/volumectl" "-u" "up"];
          "XF86AudioLowerVolume".action.spawn = ["${config.services.avizo.package}/bin/volumectl" "-u" "down"];
          "XF86AudioMute".action.spawn = ["${config.services.avizo.package}/bin/volumectl" "toggle-mute"];
          #"XF86MonBrightnessUp".action.spawn = ["${pkgs.brightnessctl}/bin/brightnessctl" "-c" "backlight" "set" "5%+"];
          #"XF86MonBrightnessDown".action.spawn = ["${pkgs.brightnessctl}/bin/brightnessctl" "-c" "backlight" "set" "5%-"];
          #"XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
          #"XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
          #"XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          "XF86AudioPlay".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "play-pause"];
          "XF86AudioNext".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "next"];
          "XF86AudioPrev".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "prev"];
          "Mod+Return".action.spawn = ["${config.programs.wezterm.package}/bin/wezterm"];
          "Mod+T".action.toggle-window-floating = {};
          "Mod+D".action.spawn = ["${config.programs.wofi.package}/bin/wofi" "-t" "wezterm" "-IS" "drun"];
          "Mod+Shift+D".action.spawn = ["${config.programs.wofi.package}/bin/wofi" "-t" "wezterm" "-IS" "run"];
          "Mod+Escape".action.spawn = ["${config.programs.wlogout.package}/bin/wlogout" "-p" "layer-shell"];
          "Mod+Shift+Escape".action.spawn = ["${config.programs.swaylock.package}/bin/swaylock" "-f"];
          #"Print".action.spawn = ["${pkgs.grimblast}/bin/grimblast" "copy" "area"];
        }
      ]);
}
