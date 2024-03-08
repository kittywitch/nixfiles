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
    inputs.hyprsome.packages.${pkgs.system}.default
  ];
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
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
      monitor = [
        "HDMI-A-2, 1920x1080, 0x0, 1"
        "eDP-1, 1920x1080, 1920x0, 1"
      ];
      workspace = ["1,monitor:eDP-1,default:true"] ++ (list.map (workspace:
        "${toString workspace},monitor:eDP-1"
      ) (list.range 2 10)) ++ [ "11,monitor:DP-3,default:true"] ++ (list.map (workspace:
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
        10);*/
      exec-once = [
        "${pkgs.libsForQt5.polkit-kde-agent}/bin/polkit-kde-agent"
        "${pkgs.networkmanagerapplet}/bin/nm-applet"
        "${pkgs.mako}/bin/mako"
        "${pkgs.swww}/bin/swww init"
        "${pkgs.systemd}/bin/systemctl --user restart waybar.service"
        "${inputs.konawall-py.packages.${pkgs.system}.konawall-py}/bin/konawall"
      ];
      xwayland = {
        force_zero_scaling = true;
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      bind =
        [
          "$mod, F, exec, firefox"
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
          "$mod, R, togglesplit,"
          "$mod, T, togglefloating,"
          "$mod, P, pseudo,"
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
