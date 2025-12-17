{ pkgs, std, lib, config, parent, ... }: let
  inherit (std) list;
  inherit (lib.meta) getExe' getExe;
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
  services = {
    swww.enable = true;
    hyprpolkitagent.enable = true;
    hyprpaper.enable = lib.mkForce false;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = let
        noctalia = "${getExe parent.services.noctalia-shell.package} ipc call";
        vol = "${noctalia} volume";
        bl = "${noctalia} brightness";
        term = getExe config.programs.alacritty.package;
    in {
      # TODO: break it up
      windowrule = [
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
        ["1,${commonOptions}"]
      ++ (list.map (
        workspace: "${toString workspace},${commonOptions}"
      ) (list.range 2 10));

      env = [
        "MOZ_ENABLE_WAYLAND,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "GDK_BACKEND,wayland,x11"
        "CLUTTER_BACKEND,wayland"
      ];
      render.direct_scanout = false;
      #debug.disable_logs = false;
      exec-once = [
        "${pkgs.swww}/bin/swww init"
        "${pkgs.dbus}/bin/dbus-update-activation-environment --all"
        "${pkgs.networkmanagerapplet}/bin/nm-applet"
        "${pkgs.udiskie}/bin/udiskie &"
        "${getExe' pkgs.systemd "systemctl"} restart konawall-py --user"
      ];
      group.groupbar = {
        # TODO: see if font necessary
      };
      xwayland = {
        force_zero_scaling = true;
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      bindl = [
        ", XF86AudioPlay, exec, ${getExe pkgs.playerctl} play-pause"
        ", XF86AudioMute, exec, ${vol} muteOutput"
        ", XF86AudioMicMute, exec, ${vol} muteInput"
      ];
      binde = [
        ", XF86AudioRaiseVolume, exec, ${vol} increase"
        ", XF86AudioLowerVolume, exec, ${vol} decrease"
        ", XF86MonBrightnessUp, exec, ${bl} increase"
        ", XF86MonBrightnessDown, exec, ${bl} decrease"
      ];
      bind = let
        uwsmCmd = lib.optionalString parent.programs.uwsm.enable "uwsm app -- ";
        uwsmApp = cmd: uwsmCmd + cmd;
        uwsmSingleApp = cmd: "pgrep ${cmd} || ${uwsmCmd + cmd}";
      in
        [
          ", XF86AudioPlay, exec, ${getExe pkgs.playerctl} play-pause"
          ", XF86AudioNext, exec, ${getExe pkgs.playerctl} next"
          ", XF86AudioPrev, exec, ${getExe pkgs.playerctl} prev"

          "$mod, D, exec, ${getExe config.programs.vicinae.package} toggle"
          "$mod, RETURN,  exec, ${uwsmApp term}"
          "$mod, W,  exec, ${uwsmApp "librewolf"}"
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
          "$mod, Escape, exec, ${noctalia} sessionMenu toggle"
          "$mod SHIFT, Escape, exec, ${noctalia} controlCenter toggle"
          "$mod, L, exec, ${uwsmSingleApp "${noctalia} lockScreen toggle"}"

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

          "$mod, bracketleft, workspace, e-1"
          "$mod, bracketright, workspace, e+1"

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
          ]
        )
          10)
      );
    };
  };
}
