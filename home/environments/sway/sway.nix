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
  programs.zsh.profileExtra = ''
    # If running from tty1 start sway
      if [ "$(tty)" = "/dev/tty1" ]; then
      systemctl --user unset-environment \
        SWAYSOCK \
        I3SOCK \
        WAYLAND_DISPLAY \
        DISPLAY \
        IN_NIX_SHELL \
        __HM_SESS_VARS_SOURCED \
        GPG_TTY \
        NIX_PATH \
        SHLVL
      exec env --unset=SHLVL systemd-cat -t sway -- sway
      fi
  '';

  home = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "Unity";
      XDG_SESSION_TYPE = "wayland";
      WLR_DRM_DEVICES = "/dev/dri/card0";
    };
    packages = with pkgs; [
      grim
      slurp
      swaylock-fancy
      wl-clipboard
      jq
      quintom-cursor-theme
      gsettings-desktop-schemas
      glib
      wofi
      wmctrl
    ];
  };

  services = {
    i3gopher.enable = true;
  };

  wayland.windowManager.sway = let
    cfg = config.wayland.windowManager.sway.config;
  in {
    enable = true;
    config = let
      super = "Mod4";
      alt = "Mod1";
      actionMode = "(l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown";
      gapsMode = "Gaps: (o) outer, (i) inner";
      gapsOuterMode = "Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)";
      gapsInnerMode = "Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)";
      lockCommand = "${pkgs.swaylock}/bin/swaylock";
    in {
      bars = [];

      modes = let
        defaultPath = {
          "Return" = "mode default";
          "Escape" = "mode default";
          "${cfg.modifier}+z" = "mode default";
        };
      in {
        ${gapsOuterMode} =
          defaultPath
          // {
            "equal" = "gaps outer current plus 5";
            "minus" = "gaps outer current minus 5";
            "0" = "gaps outer current set 0";
            "plus" = "gaps outer all plus 5";
            "Shift+minus" = "gaps outer all minus 5";
            "Shift+0" = "gaps outer all set 0";
          };
        ${gapsInnerMode} =
          defaultPath
          // {
            "equal" = "gaps inner current plus 5";
            "minus" = "gaps inner current minus 5";
            "0" = "gaps inner current set 0";
            "plus" = "gaps inner all plus 5";
            "Shift+minus" = "gaps inner all minus 5";
            "Shift+0" = "gaps inner all set 0";
          };
        ${gapsMode} =
          defaultPath
          // {
            "o" = "mode ${gapsOuterMode}";
            "i" = "mode ${gapsInnerMode}";
          };
        ${actionMode} =
          defaultPath
          // {
            "l" = "exec ${lockCommand}, mode default";
            "e" = "exec swaymsg exit, mode default";
            "s" = "exec systemctl suspend, mode default";
            "h" = "exec systemctl hibernate, mode default";
            "r" = "exec systemctl reboot, mode default";
            "Shift+s" = "exec systemctl shutdown, mode default";
          };
        resize =
          defaultPath
          // {
            "a" = "resize shrink width 4 px or 4 ppt";
            "s" = "resize shrink height 4 px or 4 ppt";
            "w" = "resize grow height 4 px or 4 ppt";
            "d" = "resize grow width 4 px or 4 ppt";
            "Left" = "resize shrink width 4 px or 4 ppt";
            "Down" = "resize shrink height 4 px or 4 ppt";
            "Up" = "resize grow height 4 px or 4 ppt";
            "Right" = "resize grow width 4 px or 4 ppt";
          };
      };

      input = {
        "*" = {
          xkb_layout = "us_gbp_map";
          xkb_options = "compose:rctrl,ctrl:nocaps";
        };
      };

      gaps = {
        smartBorders = "no_gaps";
      };

      fonts = {
        names = ["Iosevka"];
        style = "Regular";
        size = 10.0;
      };

      terminal = "${pkgs.wezterm}/bin/wezterm";
      modifier = super;

      startup = [
      ];

      window = {
        border = 1;
        titlebar = false;
        hideEdgeBorders = "smart";
      };

      workspaceAutoBackAndForth = true;

      floating = {
        border = 1;
        titlebar = false;
      };

      keybindings = let
        pactl = "${config.home.nixosConfig.hardware.pulseaudio.package or pkgs.pulseaudio}/bin/pactl";
        bindWorkspace = key: workspace: {
          "${cfg.modifier}+${key}" = "workspace number ${workspace}";
          "${cfg.modifier}+shift+${key}" = "move container to workspace number ${workspace}";
        };
        workspaceBindings =
          list.map (v: bindWorkspace v "${v}") (list.map builtins.toString (list.range 1 9))
          ++ [
            (
              bindWorkspace "0" "10"
            )
          ]
          ++ list.imap (i: v: bindWorkspace v "${toString (11 + i)}") (list.map (n: "F${builtins.toString n}") (std.list.range 1 12));
      in
        mkMerge ([
            {
              # modes
              "${cfg.modifier}+Shift+g" = ''mode "${gapsMode}"'';
              "${cfg.modifier}+Delete" = ''mode "${actionMode}"'';

              # focus windows - ESDF
              "${cfg.modifier}+s" = "focus left";
              "${cfg.modifier}+d" = "focus down";
              "${cfg.modifier}+e" = "focus up";
              "${cfg.modifier}+f" = "focus right";

              # focus windows - arrows
              "${cfg.modifier}+Left" = "focus left";
              "${cfg.modifier}+Down" = "focus down";
              "${cfg.modifier}+Up" = "focus up";
              "${cfg.modifier}+Right" = "focus right";

              # move window / container - ESDF
              "${cfg.modifier}+Shift+s" = "move left";
              "${cfg.modifier}+Shift+d" = "move down";
              "${cfg.modifier}+Shift+e" = "move up";
              "${cfg.modifier}+Shift+f" = "move right";

              # move window / container - arrows
              "${cfg.modifier}+Shift+Left" = "move left";
              "${cfg.modifier}+Shift+Down" = "move down";
              "${cfg.modifier}+Shift+Up" = "move up";
              "${cfg.modifier}+Shift+Right" = "move right";

              # focus output - ESDF
              "${cfg.modifier}+control+s" = "focus output left";
              "${cfg.modifier}+control+d" = "focus output down";
              "${cfg.modifier}+control+e" = "focus output up";
              "${cfg.modifier}+control+f" = "focus output right";

              # focus output - arrows
              "${cfg.modifier}+control+Left" = "focus output left";
              "${cfg.modifier}+control+Down" = "focus output down";
              "${cfg.modifier}+control+Up" = "focus output up";
              "${cfg.modifier}+control+Right" = "focus output right";

              # move container to output - ESDF
              "${cfg.modifier}+control+Shift+s" = "move container to output left";
              "${cfg.modifier}+control+Shift+d" = "move container to output down";
              "${cfg.modifier}+control+Shift+e" = "move container to output up";
              "${cfg.modifier}+control+Shift+f" = "move container to output right";

              # move container to output - arrows
              "${cfg.modifier}+control+Shift+Left" = "move container to output left";
              "${cfg.modifier}+control+Shift+Down" = "move container to output down";
              "${cfg.modifier}+control+Shift+Up" = "move container to output up";
              "${cfg.modifier}+control+Shift+Right" = "move container to output right";

              # move workspace to output - ESDF
              "${cfg.modifier}+control+Shift+Mod1+s" = "move workspace to output left";
              "${cfg.modifier}+control+Shift+Mod1+d" = "move workspace to output down";
              "${cfg.modifier}+control+Shift+Mod1+e" = "move workspace to output up";
              "${cfg.modifier}+control+Shift+Mod1+f" = "move workspace to output right";

              # move workspace to output - arrows
              "${cfg.modifier}+control+Shift+Mod1+Left" = "move workspace to output left";
              "${cfg.modifier}+control+Shift+Mod1+Down" = "move workspace to output down";
              "${cfg.modifier}+control+Shift+Mod1+Up" = "move workspace to output up";
              "${cfg.modifier}+control+Shift+Mod1+Right" = "move workspace to output right";

              # process management - q
              "${cfg.modifier}+q" = "exec ${cfg.menu}";
              "${cfg.modifier}+Shift+q" = "kill";
              "${cfg.modifier}+control+q" = "exec ${cfg.terminal}";

              # focus parent/child - w
              "${cfg.modifier}+w" = "focus parent";
              "${cfg.modifier}+Shift+w" = "focus child";
              # unused control

              # split management - a
              "${cfg.modifier}+a" = "splith";
              "${cfg.modifier}+Shift+a" = "splitv";
              "${cfg.modifier}+control+A" = "layout toggle split";

              # resizing, reloading - r
              # unused base
              "${cfg.modifier}+Shift+r" = "mode resize";
              "${cfg.modifier}+control+r" = "reload";

              # layout handling - t
              "${cfg.modifier}+t" = "layout tabbed";
              "${cfg.modifier}+Shift+t" = "layout stacking";
              "${cfg.modifier}+control+t" = "fullscreen toggle";

              # locking - l
              "${cfg.modifier}+l" = "exec ${lockCommand}";
              # unused shift
              # unused control
              "control+${alt}+Delete" = "exec ${lockCommand}";

              # floating - p
              "${cfg.modifier}+p" = "focus mode_toggle";
              "${cfg.modifier}+Shift+p" = "floating toggle";
              # unused control

              # workspace history switching - tab
              "${cfg.modifier}+Tab" = "workspace back_and_forth";
              "${cfg.modifier}+Shift+Tab" = "exec ${config.services.i3gopher.focus-last}";
              # unused control

              # multimedia / laptop
              "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
              "XF86AudioLowerVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
              "XF86AudioRaiseVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
              "XF86AudioMute" = "exec --no-startup-id ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
              "XF86AudioMute+Shift" = "exec --no-startup-id ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
              "XF86AudioMicMute" = "exec --no-startup-id ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
              "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
              "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
            }
          ]
          ++ workspaceBindings);

      colors = let
        inherit (config.base16) palette;
      in {
        focused = {
          border = palette.base01;
          background = palette.base0D;
          text = palette.base07;
          indicator = palette.base0D;
          childBorder = palette.base0D;
        };
        focusedInactive = {
          border = palette.base02;
          background = palette.base04;
          text = palette.base00;
          indicator = palette.base04;
          childBorder = palette.base04;
        };
        unfocused = {
          border = palette.base01;
          background = palette.base02;
          text = palette.base06;
          indicator = palette.base02;
          childBorder = palette.base02;
        };
        urgent = {
          border = palette.base03;
          background = palette.base08;
          text = palette.base00;
          indicator = palette.base08;
          childBorder = palette.base08;
        };
      };

      seat.seat0.xcursor_theme = ''"Quintom Snow" 20'';
    };

    wrapperFeatures.gtk = true;

    extraConfig = ''
      title_align center
    '';
  };
}
