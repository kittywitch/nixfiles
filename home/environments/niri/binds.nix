{
  config,
  parent,
  pkgs,
  lib,
  std,
  ...
}: let
  inherit (std) list;
  inherit (lib.meta) getExe getExe';
  inherit (lib.modules) mkMerge mkIf;
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
    # See tip near https://github.com/sodiboo/niri-flake/blob/main/docs.md#user-content-programsnirisettingsbindsnameaction
    sh = config.lib.niri.actions.spawn "sh" "-c";
    #                                                    ▀▀█
    #   ▄▄▄▄    ▄▄▄    ▄ ▄▄   ▄▄▄    ▄▄▄   ▄ ▄▄    ▄▄▄     █
    #   █▀ ▀█  █▀  █   █▀  ▀ █   ▀  █▀ ▀█  █▀  █  ▀   █    █
    #   █   █  █▀▀▀▀   █      ▀▀▀▄  █   █  █   █  ▄▀▀▀█    █
    #   ██▄█▀  ▀█▄▄▀   █     ▀▄▄▄▀  ▀█▄█▀  █   █  ▀▄▄▀█    ▀▄▄
    #   █
    #   ▀
    #
    personalBindings = {
      "Mod+Return".action = sh ''${getExe config.programs.alacritty.package}'';
      "Mod+T".action.toggle-window-floating = {};
      "Mod+D".action = sh ''${getExe config.programs.fuzzel.package} -D no -T "${getExe config.programs.alacritty.package} --command"'';
      "Mod+Escape".action = sh ''${getExe config.programs.wlogout.package} -p layer-shell'';
      "Mod+Shift+Escape".action = sh ''${getExe config.programs.swaylock.package} -f'';
      "Mod+Alt+Tab" = {
      #repeat = false;
      cooldown-ms = 150;
      action.spawn = ["${getExe' pkgs.glib "gdbus"}" "call" "--session" "--dest" "io.github.isaksamsten.Niriswitcher" "--object-path" "/io/github/isaksamsten/Niriswitcher" "--method" "io.github.isaksamsten.Niriswitcher.application"];
      };
      "Mod+Alt+Shift+Tab" = {
        cooldown-ms = 150;
        #repeat = false;
        action.spawn = ["${getExe' pkgs.glib "gdbus"}" "call" "--session" "--dest" "io.github.isaksamsten.Niriswitcher" "--object-path" "/io/github/isaksamsten/Niriswitcher" "--method" "io.github.isaksamsten.Niriswitcher.application"];
      };
    };
    #            ▄                  █
    #    ▄▄▄   ▄▄█▄▄   ▄▄▄    ▄▄▄   █   ▄
    #   █   ▀    █    █▀ ▀█  █▀  ▀  █ ▄▀
    #    ▀▀▀▄    █    █   █  █      █▀█
    #   ▀▄▄▄▀    ▀▄▄  ▀█▄█▀  ▀█▄▄▀  █  ▀▄
    #
    stockBindings = {
          # Taken from https://github.com/sodiboo/niri-flake/issues/483

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
    };
    #                     █    ▀
    #   ▄▄▄▄▄   ▄▄▄    ▄▄▄█  ▄▄▄     ▄▄▄
    #   █ █ █  █▀  █  █▀ ▀█    █    ▀   █
    #   █ █ █  █▀▀▀▀  █   █    █    ▄▀▀▀█
    #   █ █ █  ▀█▄▄▀  ▀█▄██  ▄▄█▄▄  ▀▄▄▀█
    #
    mediaBindingsCommon = {
      "XF86AudioPlay".action = sh ''${getExe pkgs.playerctl} play-pause'';
      "XF86AudioNext".action = sh ''${getExe pkgs.playerctl} next'';
      "XF86AudioPrev".action = sh ''${getExe pkgs.playerctl} prev'';
    };
    mediaBindingsAvizo = let
        lightctl = getExe' config.services.avizo.package "lightctl";
        volumectl = getExe' config.services.avizo.package "volumectl";
      in mkIf config.services.avizo.enable {
      "XF86MonBrightnessUp".action = sh ''${lightctl} up'';
      "XF86MonBrightnessDown".action = sh ''${volumectl} down'';
      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action = sh ''${volumectl} -u up'';
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action = sh ''${volumectl} -u down'';
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action = sh ''${volumectl} toggle-mute'';
      };
    };
    mediaBindingsSwayOSD = let
        swayosd-client = getExe' config.services.swayosd.package "swayosd-client";
      in mkIf config.services.swayosd.enable {
      "XF86MonBrightnessUp".action = sh ''${swayosd-client} --brightness raise'';
      "XF86MonBrightnessDown".action = sh ''${swayosd-client} --brightness lower'';
      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action = sh ''${swayosd-client} --output-volume 2'';
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action = sh ''${swayosd-client} --output-volume -2'';
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action = sh ''${swayosd-client} --output-volume mute-toggle'';
      };
    };
    mediaBindingsAvizoless = mkIf (!(config.services.avizo.enable || config.services.swayosd.enable)) {
          "XF86MonBrightnessUp".action = sh ''${getExe pkgs.brightnessctl} -c backlight set 5%+'';
          "XF86MonBrightnessDown".action = sh ''${getExe pkgs.brightnessctl} -c backlight set 5%-'';
          "XF86AudioRaiseVolume".action = sh ''${parent.services.wireplumber.package}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+'';
          "XF86AudioLowerVolume".action = sh ''${parent.services.wireplumber.package}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-'';
          "XF86AudioMute".action = sh ''${parent.services.wireplumber.package}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'';
    };
  in
    mkMerge (workspaceBindings ++ [
        stockBindings
        personalBindings
        mediaBindingsCommon
        mediaBindingsAvizo
        mediaBindingsSwayOSD
        mediaBindingsAvizoless
    ]);
}
