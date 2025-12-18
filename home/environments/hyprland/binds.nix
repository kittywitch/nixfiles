{ config, lib, std, parent, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = let
    inherit (std) list;
    inherit (lib.meta) getExe' getExe;
    noctalia = "${getExe parent.services.noctalia-shell.package} ipc call";
    vol = "${noctalia} volume";
    bl = "${noctalia} brightness";
    term = getExe config.programs.alacritty.package;
  in {
    "$mod" = "SUPER";
    binds.workspace_back_and_forth = true;
    misc = {
      session_lock_xray = true;
      key_press_enables_dpms = true;
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

        "$mod, RETURN, exec, ${getExe config.programs.vicinae.package} toggle"
        "$mod, grave,  exec, ${term}"
        "$mod SHIFT, grave,  exec, ${term} --class AlacrittyFloating"
        ", Print, exec, ${uwsmSingleApp "grimblast"} copy area"
        "CTRL ALT, DELETE, exec, ${uwsmApp "hyprctl kill"}"
        "CTRL ALT SHIFT, DELETE, exec, loginctl terminate-user \"\""

        "$mod SHIFT, Q, hy3:killactive,"
        "$mod, F, fullscreenstate, 2 -1" # dont inform
        "$mod SHIFT, F, fullscreenstate, -1 2" # do inform
        "$mod, T, togglefloating,"
        "$mod, tab, hy3:togglefocuslayer"
        "$mod SHIFT, T, togglesplit,"
        "$mod SHIFT, X, pseudo,"
        "$mod ALT, ,resizeactive,"
        "$mod, Escape, exec, ${noctalia} sessionMenu toggle"
        "$mod SHIFT, Escape, exec, ${noctalia} controlCenter toggle"
        "$mod, L, exec, ${noctalia} lockScreen lock"
        "$mod, d, hy3:makegroup, h"
        "$mod, s, hy3:makegroup, v"
        "$mod, z, hy3:makegroup, tab"
        "$mod, x, hy3:locktab, tab"
        "$mod, a, hy3:changefocus, raise"
        "$mod SHIFT, a, hy3:changefocus, lower"
        "$mod, e, hy3:expand, expand"
        "$mod SHIFT, e, hy3:expand, base"
        "$mod, r, hy3:changegroup, opposite"


        "$mod, left, hy3:movefocus, l"
        "$mod, right, hy3:movefocus, r"
        "$mod, up, hy3:movefocus, u"
        "$mod, down, hy3:movefocus, d"

        "$mod SHIFT, left, hy3:movewindow, l, once"
        "$mod SHIFT, right, hy3:movewindow, r, once"
        "$mod SHIFT, up, hy3:movewindow, u, once"
        "$mod SHIFT, down, hy3:movewindow, d, once"

        "$mod CTRL, left, hy3:movefocus, l, visible, nowarp"
        "$mod CTRL, right, hy3:movefocus, r, visible, nowarp"
        "$mod CTRL, up, hy3:movefocus, u, visible, nowarp"
        "$mod CTRL, down, hy3:movefocus, d, visible, nowarp"

        "$mod CTRL SHIFT, left, hy3:movewindow, l, once, visible"
        "$mod CTRL SHIFT, right, hy3:movewindow, r, once, visible"
        "$mod CTRL SHIFT, up, hy3:movewindow, u, once, visible"
        "$mod CTRL SHIFT, down, hy3:movewindow, d, once, visible"

        "$mod, c, togglespecialworkspace"
        "$mod SHIFT, c, movetoworkspace, special"

        "$mod, P, exec, ${getExe pkgs.hyprpicker} -na"

        "CTRL, Print, exec, ${uwsmSingleApp "grimblast"} --notify --cursor copysave output"
        "$mod SHIFT CTRL, R, exec, ${uwsmSingleApp "grimblast"} --notify --cursor copysave output"

        "ALT, Print, exec, ${uwsmSingleApp "grimblast"} --notify --cursor copysave screen"
        "$mod SHIFT ALT, R, exec, ${uwsmSingleApp "grimblast"} --notify --cursor copysave screen"

        "$mod, page_down, workspace, e-1"
        "$mod, page_up, workspace, e+1"

        "$mod, bracketleft, focusmonitor, l"
        "$mod, bracketright, focusmonitor, r"

        "$mod SHIFT, bracketleft, movewindow, mon:-1"
        "$mod SHIFT, bracketright, movewindow, mon:+1"

        "$mod CTRL SHIFT, bracketleft, movecurrentworkspacetomonitor, l"
        "$mod CTRL SHIFT, bracketright, movecurrentworkspacetomonitor, r"
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
            "$mod SHIFT, ${ws}, hy3:movetoworkspace, ${toString (x + 1)}"
            "$mod, F${ws}, workspace, ${toString (x + 11)}"
            "$mod SHIFT, F${ws}, hy3:movetoworkspace, ${toString (x + 11)}"
          ]
        )
          10)
      );
  };
}
