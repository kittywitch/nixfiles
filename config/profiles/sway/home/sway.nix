{ config, pkgs, lib, witch, ... }:

{
  config = lib.mkIf config.deploy.profile.sway {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
    };

    home.packages = with pkgs; [ grim slurp wl-clipboard jq ];

    wayland.windowManager.sway = {
      enable = true;
      config = let
        dmenu =
          "${pkgs.bemenu}/bin/bemenu --fn '${witch.style.font.name} ${witch.style.font.size}' --nb '${witch.style.base16.color0}' --nf '${witch.style.base16.color7}' --sb '${witch.style.base16.color1}' --sf '${witch.style.base16.color7}' -l 5 -m -1 -i";
        lockCommand = "swaylock -i ${./wallpapers/main.png} -s fill";
        cfg = config.wayland.windowManager.sway.config;
      in {
        bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

        output = let
          left = {
            res = "1920x1080";
            pos = "0 0";
            bg = "${./wallpapers/left.jpg} fill";
          };
          middle = {
            res = "1920x1080";
            pos = "1920 0";
            bg = "${./wallpapers/main.png} fill";
          };
          right = {
            res = "1920x1080";
            pos = "3840 0";
            bg = "${./wallpapers/right.jpg} fill";
          };
          laptop = {
            res = "1920x1080";
            pos = "0 0";
            bg = "${./wallpapers/main.png} fill";
          };
        in {
          "DP-1" = left;
          "DVI-D-1" = right;
          "HDMI-A-1" = middle;
          "eDP-1" = laptop;
        };

        input = {
          "1739:33362:Synaptics_TM3336-002" = {
            dwt = "enabled";
            tap = "enabled";
            natural_scroll = "enabled";
            middle_emulation = "enabled";
            click_method = "clickfinger";
          };
          "*" = {
            xkb_layout = "gb";
            # xkb_variant = "nodeadkeys";
            #   xkb_options = "ctrl:nocaps";
          };
        };

        fonts = [ "${witch.style.font.name} ${witch.style.font.size}" ];
        terminal = "${pkgs.kitty}/bin/kitty";
        # TODO: replace with wofi
        menu =
          "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --dmenu=\"${dmenu}\" --term='${cfg.terminal}'";
        modifier = "Mod4";

        startup = [
          {
            command = "systemctl --user restart mako";
            always = true;
          }
          {
            command = "mkchromecast -t";
          }
          {
            command =
              "${pkgs.swayidle}/bin/swayidle -w before-sleep '${lockCommand}'";
          }
        ];

        window = {
          border = 1;
          titlebar = true;
        };

        keybindings = {
          "${cfg.modifier}+Return" = "exec ${cfg.terminal}";

          "${cfg.modifier}+Left" = "focus left";
          "${cfg.modifier}+Down" = "focus down";
          "${cfg.modifier}+Up" = "focus up";
          "${cfg.modifier}+Right" = "focus right";

          "${cfg.modifier}+Shift+Left" = "move left";
          "${cfg.modifier}+Shift+Down" = "move down";
          "${cfg.modifier}+Shift+Up" = "move up";
          "${cfg.modifier}+Shift+Right" = "move right";

          "${cfg.modifier}+Shift+space" = "floating toggle";
          "${cfg.modifier}+space" = "focus mode_toggle";

          "${cfg.modifier}+1" = "workspace 1";
          "${cfg.modifier}+2" = "workspace 2";
          "${cfg.modifier}+3" = "workspace 3";
          "${cfg.modifier}+4" = "workspace 4";
          "${cfg.modifier}+5" = "workspace 5";
          "${cfg.modifier}+6" = "workspace 6";
          "${cfg.modifier}+7" = "workspace 7";
          "${cfg.modifier}+8" = "workspace 8";
          "${cfg.modifier}+9" = "workspace 9";
          "${cfg.modifier}+0" = "workspace 10";

          "${cfg.modifier}+Shift+1" = "move container to workspace 1";
          "${cfg.modifier}+Shift+2" = "move container to workspace 2";
          "${cfg.modifier}+Shift+3" = "move container to workspace 3";
          "${cfg.modifier}+Shift+4" = "move container to workspace 4";
          "${cfg.modifier}+Shift+5" = "move container to workspace 5";
          "${cfg.modifier}+Shift+6" = "move container to workspace 6";
          "${cfg.modifier}+Shift+7" = "move container to workspace 7";
          "${cfg.modifier}+Shift+8" = "move container to workspace 8";
          "${cfg.modifier}+Shift+9" = "move container to workspace 9";
          "${cfg.modifier}+Shift+0" = "move container to workspace 10";

          "XF86AudioRaiseVolume" =
            "exec pactl set-sink-volume $(pacmd list-sinks |awk '/* index:/{print $3}') +5%";
          "XF86AudioLowerVolume" =
            "exec pactl set-sink-volume $(pacmd list-sinks |awk '/* index:/{print $3}') -5%";
          "XF86AudioMute" =
            "exec pactl set-sink-mute $(pacmd list-sinks |awk '/* index:/{print $3}') toggle";
          "XF86AudioMicMute" =
            "exec pactl set-source-mute $(pacmd list-sources |awk '/* index:/{print $3}') toggle";
          "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
          "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";

          "${cfg.modifier}+d" = "exec ${cfg.menu}";
          "${cfg.modifier}+x" = "exec ${lockCommand}";

          "${cfg.modifier}+Print" =
            "exec ${./grimshot.sh} --notify save screen";
          "${cfg.modifier}+Shift+Print" =
            "exec ${./grimshot.sh} --notify save area";
          "${cfg.modifier}+Mod1+Print" =
            "exec ${./grimshot.sh} --notify save window";

          "${cfg.modifier}+i" = "move workspace to output left";
          "${cfg.modifier}+o" = "move workspace to output left";
          "${cfg.modifier}+b" = "splith";
          "${cfg.modifier}+v" = "splitv";
          "${cfg.modifier}+s" = "layout stacking";
          "${cfg.modifier}+w" = "layout tabbed";
          "${cfg.modifier}+e" = "layout toggle split";
          "${cfg.modifier}+f" = "fullscreen";

          "${cfg.modifier}+Shift+q" = "kill";
          "${cfg.modifier}+Shift+c" = "reload";

          "${cfg.modifier}+r" = "mode resize";
          "${cfg.modifier}+Delete" = ''
            mode "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown"'';
        };

        modes = {
          "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown" =
            {
              "l" = "exec ${lockCommand}, mode default";
              "e" = "exec swaymsg exit, mode default";
              "s" = "exec systemctl suspend, mode default";
              "h" = "exec systemctl hibernate, mode default";
              "r" = "exec systemctl reboot, mode default";
              "Shift+s" = "exec systemctl shutdown, mode default";
              "Return" = "mode default";
              "Escape" = "mode default";
            };
        };

        colors = {
          focused = {
            border = witch.style.base16.color8;
            background = witch.style.base16.color3;
            text = witch.style.base16.color0;
            indicator = witch.style.base16.color2;
            childBorder = witch.style.base16.color8;
          };
          focusedInactive = {
            border = witch.style.base16.color0;
            background = witch.style.base16.color15;
            text = witch.style.base16.color13;
            indicator = witch.style.base16.color2;
            childBorder = witch.style.base16.color8;
          };
          unfocused = {
            border = witch.style.base16.color0;
            background = witch.style.base16.color8;
            text = witch.style.base16.color7;
            indicator = witch.style.base16.color8;
            childBorder = witch.style.base16.color8;
          };
          urgent = {
            border = witch.style.base16.color0;
            background = witch.style.base16.color9;
            text = witch.style.base16.color0;
            indicator = witch.style.base16.color1;
            childBorder = witch.style.base16.color8;
          };
        };
      };
      wrapperFeatures.gtk = true;
      extraConfig = ''
        seat seat0 xcursor_theme breeze_cursors 20
      '';
    };
  };

}
