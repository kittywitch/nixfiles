{
  std,
  parent,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (std) list;
in {
  home.packages = with pkgs; [
    grimblast
    wl-clipboard
    wlr-randr
    wl-screenrec
    slurp
    grim
    swww
    pavucontrol
    hyprpicker
    brightnessctl
    playerctl
    glib
    pcmanfm
  ];
  services.hyprpolkitagent.enable = true;
  services.swww.enable = true;
  wayland.windowManager.hyprland = let
    import-gsettings = pkgs.writeShellScriptBin "import-gsettings" ''
# usage: import-gsettings
config="''${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
if [ ! -f "$config" ]; then exit 1; fi

gnome_schema="org.gnome.desktop.interface"
gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
${pkgs.glib}/bin/gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
${pkgs.glib}/bin/gsettings set "$gnome_schema" icon-theme "$icon_theme"
${pkgs.glib}/bin/gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
${pkgs.glib}/bin/gsettings set "$gnome_schema" font-name "$font_name"
    '';
  in {
    enable = true;
    systemd = {
      enable = false;
      variables = ["--all"];
      enableXdgAutostart = true;
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    settings = {
      # TODO: break it up
      windowrule = let
      in [
        "suppressevent fullscreen, class:steam_app_default"
        "workspace 2, class:steam_app_default"
        "suppressevent maximize, class:.*"
  
        "tile, class:battle\.net\.exe"

        "renderunfocused, class:discord, initialTitle:Discord"

        "unset, title:Wine System Tray"
        "workspace special:hidden silent, title:Wine System Tray"
        "noinitialfocus, title:Wine System Tray"
      ];
      "$mod" = "SUPER";
      input = {
        kb_options = "ctrl:nocaps";
        accel_profile = "flat";
        sensitivity = 1.0;
        scroll_factor = 1.0;
      };
      cursor = {
        use_cpu_buffer = true;
      };
      workspace = let
        commonOptions = "gapsin:0,gapsout:0,rounding:false";
      in
        ["1,monitor:DP-1,default:true,${commonOptions}"]
        ++ (list.map (
          workspace: "${toString workspace},monitor:DP-1${commonOptions}"
        ) (list.range 2 10))
         ++ [ "11,monitor:DP-2,default:true"] ++ (list.map (
          workspace: "${toString workspace},monitor:DP-2${commonOptions}"
        ) (list.range 12 20));
      /*list.concat (list.generate (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "${toString x},monitor:DP-1"
            "${toString (x + 10)},monitor:DP-2${commonOptions}"
          ]
        )
        10);
      */
      env = [
        "MOZ_ENABLE_WAYLAND,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "GDK_BACKEND,wayland,x11"
        "CLUTTER_BACKEND,wayland"
      ];
      render.direct_scanout = false;
      debug.disable_logs = false;
      exec-once = [
        "${pkgs.swww}/bin/swww init"
        "${pkgs.hypridle}/bin/hypridle"
        "${pkgs.dbus}/bin/dbus-update-activation-environment --all"
        "${pkgs.libsForQt5.polkit-kde-agent}/bin/polkit-kde-agent"
        "${pkgs.networkmanagerapplet}/bin/nm-applet"
        "${pkgs.mako}/bin/mako"
        "${pkgs.udiskie}/bin/udiskie &"
        "${pkgs.pasystray}/bin/pasystray"
        "${pkgs.systemd}/bin/systemctl restart waybar --user"
        "${pkgs.systemd}/bin/systemctl restart konawall-py --user"
        "legcord --enable-features=WaylandLinuxDrmSyncobj,UseOzonePlatform --ozone-platform=wayland"
        "spotify --enable-features=WaylandLinuxDrmSyncobj,UseOzonePlatform --ozone-platform=wayland"
      ];
      plugin.split-monitor-workspaces = {
        count = 10;
        keep_focused = 0;
        enable_notifications = 0;
        enable_persistent_workspaces = 1;
      };
      group.groupbar = {
        font_family = "Monaspace Krypton";
        font_size = 12;
      };
      exec = [
        "${import-gsettings}/bin/import-gsettings"
      ];
      xwayland = {
        force_zero_scaling = true;
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      bindl = [
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight set 5%+"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight set 5%-"
      ];
      bind = let
        uwsmCmd = lib.optionalString parent.programs.uwsm.enable "uwsm app -- ";
        uwsmApp = cmd: uwsmCmd + cmd;
        uwsmSingleApp = cmd: "pgrep ${cmd} || ${uwsmCmd + cmd}";
      in [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl prev"

          "$mod, R, exec, wofi -t wezterm -IS drun"
          "$mod SHIFT, R, exec, wofi -t wezterm -IS run"
          "$mod, RETURN,  exec, ${uwsmApp "wezterm"}"
          "$mod, W,  exec, ${uwsmApp "firefox"}"
          "$mod, E,  exec, ${uwsmApp "pcmanfm"}"
          ", Print, exec, ${uwsmSingleApp "grimblast"} copy area"
          "CTRL ALT, DELETE, exec, ${uwsmApp "hyprctl kill"}"
          "CTRL ALT SHIFT, DELETE, exec, loginctl terminate-user \"\""

          "$mod SHIFT, E, exec, pkill Hyprland"
          "$mod SHIFT, Q, killactive,"
          "$mod, F, fullscreenstate, 2 -1" # dont inform
          "$mod SHIFT, F, fullscreenstate, -1 2" # do inform
          "$mod, G, togglegroup,"
          "$mod SHIFT, N, changegroupactive, f"
          "$mod SHIFT, P, changegroupactive, b"
          "$mod, T, togglefloating,"
          "$mod SHIFT, T, togglesplit,"
          "$mod SHIFT, X, pseudo,"
          "$mod ALT, ,resizeactive,"
          "$mod, Escape, exec, wlogout -p layer-shell"
          "$mod, L, exec, ${uwsmSingleApp "hyprlock"}"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
          "$mod ALT, left, movewindoworgroup, l"
          "$mod ALT, right, movewindoworgroup, r"
          "$mod ALT, up, movewindoworgroup, u"
          "$mod ALT, down, movewindoworgroup, d"

          "$mod, P, exec, ${pkgs.hyprpicker}/bin/hyprpicker -na"

          "CTRL, Print, exec, ${uwsmSingleApp "grimblast"} --notify --cursor copysave output"
          "$mod SHIFT CTRL, R, exec, ${uwsmSingleApp "grimblast"} --notify --cursor copysave output"

          "ALT, Print, exec, ${uwsmSingleApp "grimblast"} --notify --cursor copysave screen"
          "$mod SHIFT ALT, R, exec, ${uwsmSingleApp "grimblast"} --notify --cursor copysave screen"

          "$mod, bracketleft, workspace, m-1"
          "$mod, bracketright, workspace, m+1"

          "$mod SHIFT, bracketleft, focusmonitor, l"
          "$mod SHIFT, bracketright, focusmonitor, r"

          "$mod SHIFT ALT, bracketleft, movecurrentworkspacetomonitor, l"
          "$mod SHIFT ALT, bracketright, movecurrentworkspacetomonitor, r"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          list.concat (list.generate (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
                "$mod, F${if ws == "0" then "10" else ws}, workspace, ${toString (x + 11)}"
                "$mod SHIFT, F${if ws == "0" then "10" else ws}, movetoworkspacesilent, ${toString (x + 11)}"
  
                "$mod ALT, ${ws}, split-workspace, ${toString (x + 1)}"
                "$mod SHIFT ALT, ${ws}, split-movetoworkspacesilent, ${toString (x + 1)}"
                "$mod ALT, F${if ws == "0" then "10" else ws}, split-workspace, ${toString (x + 11)}"
                "$mod SHIFT ALT, F${if ws == "0" then "10" else ws}, split-movetoworkspacesilent, ${toString (x + 11)}"
              ]
            )
            10)
        );
    };
  };
}
