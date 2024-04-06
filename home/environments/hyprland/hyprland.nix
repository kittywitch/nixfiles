{
  config,
  lib,
  std,
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
    gnome.nautilus
    brightnessctl
    playerctl
    inputs.hyprsome.packages.${pkgs.system}.default
  ];
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
      extraCommands = [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
    };
    xwayland.enable = true;
    settings = {
      "$mod" = "SUPER";
      input = {
        kb_options = "ctrl:nocaps";
      };
      workspace = let
        commonOptions = "gapsin:0,gapsout:0,rounding:false";
      in
        ["1,monitor:eDP-1,default:true,${commonOptions}"]
        ++ (list.map (
          workspace: "${toString workspace},monitor:eDP-1${commonOptions}"
        ) (list.range 2 10));
      /*
                              ++ [ "11,monitor:DP-3,default:true"] ++ (list.map (workspace:
        "${toString workspace},monitor:DP-3"
      ) (list.range 12 20));
      /*list.concat (list.generate (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "${toString x},monitor:eDP-1"
            "${toString (x + 10)},monitor:DP-3"
          ]
        )
        10);
      */
      monitor = [
        "eDP-1, 2256x1504, 0x0, 1"
      ];
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
      ];
      exec = [
      ];
      xwayland = {
        force_zero_scaling = true;
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight set 5%+"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl -c backlight set 5%-"
      ];
      bind =
        [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl prev"

          "$mod, R, exec, wofi -t wezterm -IS drun"
          "$mod SHIFT, R, exec, wofi -t wezterm -IS run"
          "$mod, Return, exec, wezterm"
          ", Print, exec, grimblast copy area"

          "$mod SHIFT, E, exec, pkill Hyprland"
          "$mod, Q, killactive,"
          "$mod, F, fullscreen,"
          "$mod, G, togglegroup,"
          "$mod SHIFT, N, changegroupactive, f"
          "$mod SHIFT, P, changegroupactive, b"
          "$mod, T, togglefloating,"
          "$mod SHIFT, T, togglesplit,"
          "$mod SHIFT, X, pseudo,"
          "$mod ALT, ,resizeactive,"
          "$mod, Escape, exec, wlogout -p layer-shell"
          "$mod, L, exec, loginctl lock-session"

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

          "CTRL, Print, exec, grimblast --notify --cursor copysave output"
          "$mod SHIFT CTRL, R, exec, grimblast --notify --cursor copysave output"

          "ALT, Print, exec, grimblast --notify --cursor copysave screen"
          "$mod SHIFT ALT, R, exec, grimblast --notify --cursor copysave screen"

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
                "$mod, ${ws}, exec, hyprsome workspace ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, exec, hyprsome move ${toString (x + 1)}"
              ]
            )
            10)
        );
    };
  };
}
