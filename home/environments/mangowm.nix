{ lib, parent, pkgs, std, ... }: let
  inherit (lib.meta) getExe' getExe;
  inherit (std) list string;
  wireplumber = parent.services.pipewire.wireplumber.package;
in {
  home.packages = with pkgs; [
    grim
    slurp
    satty
  ];
  programs.fuzzel = {
    enable = true;
  };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.main = {
      layer = "top";
      position = "top";
      modules-left = [ "ext/workspaces" "dwl/window" ];
      modules-right = [ "tray" "clock" ];
      "ext/workspaces" = {
        format = "{icon}";
        ignore-hidden = true;
        on-click = "activate";
        on-click-right = "deactivate";
        sort-by-id = true;
      };
      "dwl/window" = {
        format = "[{layout}] {title}";
      };
      clock = {
        format = "{:%F %T %Z}";
        interval = 1;
      };
    };
    style = ''
      * {
        font-family: "Atkinson Hyperlegible Next", monospace;
        font-size: 16px;
      }
    '';
  };
  wayland.windowManager.mango = {
    enable = true;
    settings = let
      workspaceMap = f: list.map (t: let ts = string.unsafeConvert t; in f ts) (list.range 1 9);
      workspaceMapSep = f: string.concatSep "\n" (workspaceMap f);
      genBind = keys: verb: target: "bind=${keys},${verb},${target}";
      mappedViews = workspaceMapSep (t: genBind "Alt,${t}" "view" "${t},0");
      mappedTags = workspaceMapSep (t: genBind "Alt+Shift,${t}" "tag" "${t},0");
      mappedToggleViews = workspaceMapSep (t: genBind "Super,${t}" "toggleview" "${t},0");
      mappedToggleTags = workspaceMapSep (t: genBind "Super+Shift,${t}" "toggletag" "${t},0");
    in ''
      monitorrule=model:LG Ultra HD,width:2560,height:1440,refresh:59.951,x:1920,y:0
      monitorrule=model:SAMSUNG,x:0,y:0

      shadows=1
      layer_shadows=1
      blur=1
      blur_optimized=1

      bind=CTRL+ALT,a,spawn_shell,grim -g "$(slurp)" -t ppm - | satty -f -
      # the rule is to avoid occlusion and ghosting
      layerrule=noanim:1,noblur:1,layer_name:selection

      bind=SUPER,r,reload_config
      bind=Alt,Return,spawn,alacritty
      bind=Alt,d,spawn,fuzzel
      bind=Alt,q,killclient
      bind=Alt+Shift,e,quit

      # switch window focus
      bind=SUPER,Tab,focusstack,next
      bind=SUPER,u,focuslast
      bind=Ctrl,Left,focusdir,left
      bind=Ctrl,Right,focusdir,right
      bind=Ctrl,Up,focusdir,up
      bind=Ctrl,Down,focusdir,down

      # swap window
      bind=SUPER+SHIFT,Up,exchange_client,up
      bind=SUPER+SHIFT,Down,exchange_client,down
      bind=SUPER+SHIFT,Left,exchange_client,left
      bind=SUPER+SHIFT,Right,exchange_client,right

      # movewin
      bind=CTRL+SHIFT,Up,movewin,+0,-50
      bind=CTRL+SHIFT,Down,movewin,+0,+50
      bind=CTRL+SHIFT,Left,movewin,-50,+0
      bind=CTRL+SHIFT,Right,movewin,+50,+0


      # resizewin
      bind=CTRL+ALT,Up,resizewin,+0,-50
      bind=CTRL+ALT,Down,resizewin,+0,+50
      bind=CTRL+ALT,Left,resizewin,-50,+0
      bind=CTRL+ALT,Right,resizewin,+50,+0

      # switch window status
      bind=SUPER,g,toggleglobal,
      bind=ALT,Tab,toggleoverview,0
      bind=ALT,backslash,togglefloating,
      bind=ALT,a,togglemaximizescreen,
      bind=ALT,f,togglefullscreen,
      bind=ALT+SHIFT,f,togglefakefullscreen,
      bind=SUPER,i,minimized,
      bind=SUPER,o,toggleoverlay,
      bind=SUPER+SHIFT,I,restore_minimized
      bind=ALT,z,toggle_scratchpad

      # scroller layout
      bind=ALT,e,set_proportion,1.0
      bind=ALT,x,switch_proportion_preset,

      # tile layout
      bind=SUPER,e,incnmaster,1
      bind=SUPER,t,incnmaster,-1
      bind=ALT,s,zoom,

      # switch layout
      bind=CTRL+SUPER,i,setlayout,tile
      bind=CTRL+SUPER,l,setlayout,scroller
      bind=SUPER,n,switch_layout

      # tag switch
      bind=SUPER,Left,viewtoleft,0
      bind=CTRL,Left,viewtoleft_have_client,0
      bind=SUPER,Right,viewtoright,0
      bind=CTRL,Right,viewtoright_have_client,0
      bind=CTRL+SUPER,Left,tagtoleft,0
      bind=CTRL+SUPER,Right,tagtoright,0

      ${mappedViews}
      ${mappedTags}
      ${mappedToggleViews}
      ${mappedToggleTags}


      # monitor switch
      bind=alt+shift,Left,focusmon,left
      bind=alt+shift,Right,focusmon,right
      bind=alt+shift,Up,focusmon,up
      bind=alt+shift,Down,focusmon,down
      bind=SUPER+Alt,Left,tagmon,left
      bind=SUPER+Alt,Right,tagmon,right
      bind=SUPER+Alt,Up,tagmon,up
      bind=SUPER+Alt,Down,tagmon,down

      # gaps
      bind=ALT+SHIFT,X,incgaps,1
      bind=ALT+SHIFT,Z,incgaps,-1
      bind=ALT+SHIFT,R,togglegaps


      # Mouse Button Bindings
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=alt,btn_middle,set_proportion,0.5
      mousebind=SUPER,btn_right,moveresize,curresize
      mousebind=SUPER+CTRL,btn_left,minimized
      mousebind=SUPER+CTRL,btn_right,killclient
      mousebind=SUPER+CTRL,btn_middle,togglefullscreen

      # Axis Bindings
      axisbind=SUPER,UP,viewtoleft_have_client
      axisbind=SUPER,DOWN,viewtoright_have_client
      axisbind=alt,UP,focusdir,left
      axisbind=alt,DOWN,focusdir,right
      axisbind=shift+super,UP,exchange_client,left
      axisbind=shift+super,DOWN,exchange_client,right

      # Gesturebind
      gesturebind=none,left,3,focusdir,left
      gesturebind=none,right,3,focusdir,right
      gesturebind=none,up,3,focusdir,up
      gesturebind=none,down,3,focusdir,down
      gesturebind=none,left,4,viewtoleft_have_client
      gesturebind=none,right,4,viewtoright_have_client
      gesturebind=none,up,4,toggleoverview,1
      gesturebind=none,down,4,toggleoverview,1

      # brightness and volume
      bind=none,XF86AudioRaiseVolume,spawn,${getExe' wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.1+
      bind=none,XF86AudioLowerVolume,spawn,${getExe' wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.1-
      bind=none,XF86AudioMute,spawn,${getExe' wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind=none,XF86MonBrightnessUp,spawn,${getExe pkgs.brightnessctl} -c backlight set  5%+
      bind=none,XF86MonBrightnessDown,spawn,${getExe pkgs.brightnessctl} -c backlight set 5%-
    '';
    autostart_sh = ''
      systemctl start --user waybar
      systemctl start --user swww
      swww restore
    '';
  };
}
