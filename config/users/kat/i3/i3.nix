{ config, base16, pkgs, lib, ... }: with lib;

{
  services.i3gopher = { enable = true; };

  kw.theme.swaylock = false;

  services.polybar = {
      enable = true;
      script = let
        xrandr = filter: "${pkgs.xorg.xrandr}/bin/xrandr -q | ${pkgs.gnugrep}/bin/grep -F ' ${filter}' | ${pkgs.coreutils}/bin/cut -d' ' -f1";
      in mkIf config.xsession.enable ''
        primary=$(${xrandr "connected primary"})
        for display in $(${xrandr "connected"}); do
          export POLYBAR_MONITOR=$display
          export POLYBAR_MONITOR_PRIMARY=$([[ $primary = $display ]] && echo true || echo false)
          export POLYBAR_TRAY_POSITION=$([[ $primary = $display ]] && echo right || echo none)
          polybar arc &
        done
      '';
      package = pkgs.polybarFull;
      config = {
        "bar/base" = {
          modules-left = mkIf config.xsession.windowManager.i3.enable (
            mkBefore [ "i3" ]
          );
          modules-center = mkMerge [
            (mkIf (config.home.nixos.hardware.pulseaudio.enable or false || config.home.nixos.services.pipewire.enable or false) (mkBefore [ "pulseaudio" "mic" ]))
            (mkIf config.services.playerctld.enable [ "sep" "mpris" ])
            (mkIf (config.programs.ncmpcpp.enable && !config.services.playerctld.enable) [ "sep" "mpd" ])
          ];
          modules-right = mkMerge [
            [ "net-enp34s0" ]
            (mkOrder 1240 [ "sep" ])
            (mkOrder 1250 [ "cpu" "temp" "ram" ])
            (mkOrder 1490 [ "sep" ])
            (mkAfter [ "utc" "date" ])
          ];
        };
      };
      settings = let
        colours = base16.map.hash.argb;
        warn-colour = colours.constant; # or deleted
      in with colours; {
        "bar/arc" = {
          "inherit" = "bar/base";
          monitor = {
            text = mkIf config.xsession.enable "\${env:POLYBAR_MONITOR:}";
          };
          height = 20;
          enable-ipc = true;
          tray = {
            maxsize = 12;
            position = "\${env:POLYBAR_TRAY_POSITION:right}";
          };
          dpi = {
            x = 0;
            y = 0;
          };
          scroll = {
            up = "#i3.prev";
            down = "#i3.next";
          };
          font = [
            "${config.kw.theme.font.name}:size=9"
            "Font Awesome 5 Free Solid:size=9"
            "Font Awesome 5 Free Brands:size=9"
          ];
          padding = {
            right = 1;
          };
          separator = {
            text = " ";
            foreground = foreground_status;
          };
          background = background_status;
          foreground = foreground_alt;
          border = {
            bottom = {
              size = 1;
              color = background_light;
            };
          };
          module-margin = 0;
          #click-right = ""; menu of some sort?
        };
        "module/i3" = mkIf config.xsession.windowManager.i3.enable {
          type = "internal/i3";
          pin-workspaces = true;
          strip-wsnumbers = true;
          wrapping-scroll = false;
          enable-scroll = false; # handled by bar instead
          label = {
            mode = {
              padding = 2;
              foreground = constant;
              background = background_selection;
            };
            focused = {
              text = "%name%";
              padding = 1;
              foreground = background_alt;
              background = regex;
            };
            unfocused = {
              text = "%name%";
              padding = 1;
              foreground = foreground_alt;
              background = background_light;
            };
            /*visible = {
              text = "%name%";
              padding = 1;
              foreground = foreground;
              #background = background;
            };
            urgent = {
              text = "%name%";
              padding = 1;
              foreground = foreground_status;
              background = link;
            };*/
          };
        };
        "module/sep" = {
          type = "custom/text";
          content = {
            text = "|";
            foreground = comment;
          };
        };
        "module/ram" = {
          type = "internal/memory";
          interval = 4;
          label = "%gb_used% %percentage_used%% ~ %gb_free%";
          warn-percentage = 90;
          format.warn.foreground = warn-colour;
        };
        "module/cpu" = {
          type = "internal/cpu";
          label = "🖥️ %percentage%%"; # 🧮
          interval = 2;
          warn-percentage = 90;
          format.warn.foreground = warn-colour;
        };
        "module/mpd" = let
          ncmpcpp = config.programs.ncmpcpp;
        in mkIf ncmpcpp.enable {
          type = "internal/mpd";

          host = mkIf (ncmpcpp.mpdHost != null) ncmpcpp.mpdHost;
          password = mkIf (ncmpcpp.mpdPassword != null) ncmpcpp.mpdPassword;
          port = mkIf (ncmpcpp.mpdPort != null) ncmpcpp.mpdPort;

          interval = 1;
          label-song = "♪ %artist% - %title%";
          format = {
            online = "<label-time> <label-song>";
            playing = "\${self.format-online}";
          };
        };
        "module/net-enp34s0" = {
          type = "internal/network";
          interface = "enp34s0";
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          use-ui-max = false;
          interval = 5;
          format.volume = "<ramp-volume> <label-volume>";
          ramp.volume = [ "🔈" "🔉" "🔊" ];
          label = {
            muted = {
              text = "🔇 muted";
              foreground = warn-colour;
            };
          };
        };
        "module/date" = {
          type = "internal/date";
          label = "%date%, %time%";
          format = "<label>";
          interval = 60;
          date = "%F";
          time = "%T";
        };
        "module/utc" = {
          type = "custom/script";
          exec = "${pkgs.coreutils}/bin/date -u +%H:%M";
          format = "🕓 <label>Z";
          interval = 60;
        };
        "module/temp" = {
          type = "internal/temperature";

          interval = mkDefault 5;
          base-temperature = mkDefault 30;
          label = {
            text = "%temperature-c%";
            warn.foreground = warn-colour;
          };

          # $ for i in /sys/class/thermal/thermal_zone*; do echo "$i: $(<$i/type)"; done
          #thermal-zone = 0;

          # Full path of temperature sysfs path
          # Use `sensors` to find preferred temperature source, then run
          # $ for i in /sys/class/hwmon/hwmon*/temp*_input; do echo "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*})) $(readlink -f $i)"; done
          # Default reverts to thermal zone setting
          #hwmon-path = ?
        };
        "module/net-wlan" = {
          type = "internal/network";
          interface = mkIf (! config.home.nixos.networking.wireless.iwd.enable or false) (mkDefault "wlan");
          label = {
            connected = {
              text = "📶 %essid% %downspeed:9%";
              foreground = inserted;
            };
            disconnected = {
              text = "Disconnected.";
              foreground = warn-colour;
            };
          };
          format-packetloss = "<animation-packetloss> <label-connected>";
          animation-packetloss = [
            {
              text = "!"; # ⚠
              foreground = warn-colour;
            }
            {
              text = "📶";
              foreground = warn-colour;
            }
          ];
        };
        "module/net-wired" = {
          type = "internal/network";
          label = {
            connected = {
              text = "%ifname% %local_ip%";
              foreground = inserted;
            };
            disconnected = {
              text = "Unconnected.";
              foreground = warn-colour; # or deleted
            };
          };
          # TODO: formatting
        };
        "module/fs-prefix" = {
          type = "custom/text";
          content = {
            text = "💽";
          };
        };
        "module/fs-root" = {
          type = "internal/fs";
          mount = mkBefore [ "/" ];
          label-mounted = "%mountpoint% %free% %percentage_used%%";
          label-warn = "%mountpoint% %{F${warn-colour}}%free% %percentage_used%%%{F-}";
          label-unmounted = "";
          warn-percentage = 90;
          spacing = 1;
        };
        "module/mic" = {
          type = "custom/ipc";
          format = "🎤 <output>";
          initial = 1;
          click.left = "${config.home.nixos.hardware.pulseaudio.package or pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle && ${config.services.polybar.package}/bin/polybar-msg hook mic 1";
          # check if pa default-source is muted, if so, show warning!
          # also we trigger an immediate refresh when hitting the keybind
          hook = let
            pamixer = "${pkgs.pamixer}/bin/pamixer --default-source";
            script = pkgs.writeShellScript "checkmute" ''
              set -eu
              MUTE=$(${pamixer} --get-mute || true)
              if [[ $MUTE = true ]]; then
                echo muted
              else
                echo "$(${pamixer} --get-volume)%"
              fi
            '';
          in singleton "${script}";
        };
      };
    };


  services.dunst.enable = true;
  services.picom = {
    enable = true;
      experimentalBackends = mkDefault true;
      package = mkDefault pkgs.picom-next;
      opacityRule = [
        # https://wiki.archlinux.org/index.php/Picom#Tabbed_windows_(shadows_and_transparency)
        "100:class_g = 'URxvt' && !_NET_WM_STATE@:32a"
          "0:_NET_WM_STATE@[0]:32a *= '_NET_WM_STATE_HIDDEN'"
          "0:_NET_WM_STATE@[1]:32a *= '_NET_WM_STATE_HIDDEN'"
          "0:_NET_WM_STATE@[2]:32a *= '_NET_WM_STATE_HIDDEN'"
          "0:_NET_WM_STATE@[3]:32a *= '_NET_WM_STATE_HIDDEN'"
          "0:_NET_WM_STATE@[4]:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
      shadowExclude = [
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
  };

  home.file.".xinitrc".text = ''
  exec ~/.xsession
  '';

  xsession.enable = true;

  xsession.windowManager.i3 =
    let
      cfg = config.xsession.windowManager.i3.config;
      bindsym = k: v: "bindsym ${k} ${v}";
      bindWorkspace = key: workspace: {
        "${cfg.modifier}+${key}" = "workspace number ${workspace}";
        "${cfg.modifier}+shift+${key}" = "move container to workspace number ${workspace}";
      };
      workspaceBindings = map (v: bindWorkspace v "${v}:${v}") [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
      ]
      ++ [ (bindWorkspace "0" "10:10") ]
      ++ lib.imap1 (i: v: bindWorkspace v "${toString (10 + i)}:${v}") [
        "F1"
        "F2"
        "F3"
        "F4"
        "F5"
        "F6"
        "F7"
        "F8"
        "F9"
        "F10"
        "F11"
        "F12"
      ];
      workspaceBindings' = map (lib.mapAttrsToList bindsym) workspaceBindings;
      workspaceBindingsStr = lib.concatStringsSep "\n" (lib.flatten workspaceBindings');
      lockCommand = "${pkgs.i3lock}/bin/i3lock -e -u -c 111111";
    in
    {
      enable = true;
      package = pkgs.i3-gaps;
      config =
        let
          pactl = "${config.home.nixos.hardware.pulseaudio.package or pkgs.pulseaudio}/bin/pactl";
          #dmenu = "${pkgs.wofi}/bin/wofi -idbt ${pkgs.kitty}/bin/kitty -s ~/.config/wofi/wofi.css -p '' -W 25%";
          dmenu = pkgs.writeShellScriptBin "rofi-wrap" ''${pkgs.rofi}/bin/rofi -combi-modi window,drun,ssh -theme solarized -font 'Iosevka 10' -show combi'';
        in
        {

          modes = {
            "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown" =
              {
                "l" = "exec ${lockCommand}, mode default";
                "e" = "exit, mode default";
                "s" = "exec systemctl suspend, mode default";
                "h" = "exec systemctl hibernate, mode default";
                "r" = "exec systemctl reboot, mode default";
                "Shift+s" = "exec systemctl shutdown, mode default";
                "Return" = "mode default";
                "Escape" = "mode default";
              };
          };
          # bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];
          bars = [];

          fonts = {
            names = [ config.kw.theme.font.name ];
            style = "Regular";
            size = config.kw.theme.font.size;
          };
          terminal = "${pkgs.kitty}/bin/kitty";
          #menu = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --no-generic --dmenu=\"${dmenu}\" --term='${pkgs.kitty}/bin/kitty'";
          modifier = "Mod4";

          assigns = { "12:F2" = [{ class = "screenstub"; }]; };
          startup = [
            {
              command = "gsettings set org.gnome.desktop.interface cursor-theme 'Quintom_Snow'";
            }
            {
              command = "systemctl --user restart dunst";
              always = true;
            }
            {
              command = "systemctl --user restart konawall.service";
              always = true;
            }
          ];

          modes.resize = {
            "a" = "resize shrink width 4 px or 4 ppt";
            "s" = "resize shrink height 4 px or 4 ppt";
            "w" = "resize grow height 4 px or 4 ppt";
            "d" = "resize grow width 4 px or 4 ppt";
            "Left" = "resize shrink width 4 px or 4 ppt";
            "Down" = "resize shrink height 4 px or 4 ppt";
            "Up" = "resize grow height 4 px or 4 ppt";
            "Right" = "resize grow width 4 px or 4 ppt";
            Return = ''mode "default"'';
            Escape = ''mode "default"'';
            "${cfg.modifier}+z" = ''mode "default"'';
          };
          window = {
            border = 1;
            titlebar = false;
        hideEdgeBorders = "smart";
          };

          floating = {
            border = 1;
            titlebar = false;
          };
                focus = {
        forceWrapping = true;
      };
      workspaceAutoBackAndForth = true;

          keybindings = {
            "${cfg.modifier}+Return" = "exec ${cfg.terminal}";
            "${cfg.modifier}+x" = "exec ${lockCommand}";

            # focus windows - regular
            "${cfg.modifier}+Left" = "focus left";
            "${cfg.modifier}+Down" = "focus down";
            "${cfg.modifier}+Up" = "focus up";
            "${cfg.modifier}+Right" = "focus right";

            # move window / container - regular
            "${cfg.modifier}+shift+Left" = "move left";
            "${cfg.modifier}+shift+Down" = "move down";
            "${cfg.modifier}+shift+Up" = "move up";
            "${cfg.modifier}+shift+Right" = "move right";

            # focus output - regular
            "${cfg.modifier}+control+Left" = "focus output left";
            "${cfg.modifier}+control+Down" = "focus output down";
            "${cfg.modifier}+control+Up" = "focus output up";
            "${cfg.modifier}+control+Right" = "focus output right";

            # move container to output - regular
            "${cfg.modifier}+control+shift+Left" = "move container to output left";
            "${cfg.modifier}+control+shift+Down" = "move container to output down";
            "${cfg.modifier}+control+shift+Up" = "move container to output up";
            "${cfg.modifier}+control+shift+Right" = "move container to output right";

            # move workspace to output - regular
            "${cfg.modifier}+control+shift+Mod1+Left" = "move workspace to output left";
            "${cfg.modifier}+control+shift+Mod1+Down" = "move workspace to output down";
            "${cfg.modifier}+control+shift+Mod1+Up" = "move workspace to output up";
            "${cfg.modifier}+control+shift+Mod1+Right" = "move workspace to output right";


            # focus parent/child
            "${cfg.modifier}+q" = "focus parent";
            "${cfg.modifier}+e" = "focus child";

            # floating
            "${cfg.modifier}+Shift+space" = "floating toggle";
            "${cfg.modifier}+space" = "focus mode_toggle";

            # workspace history switching
            "${cfg.modifier}+Tab" = "workspace back_and_forth";
            "${cfg.modifier}+Shift+Tab" = "exec ${config.services.i3gopher.focus-last}";

            # multimedia / laptop
            "XF86AudioLowerVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioRaiseVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioMute" = "exec --no-startup-id ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioMute+Shift" = "exec --no-startup-id ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
            "XF86AudioMicMute" = "exec --no-startup-id ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
            "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
            "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";

            # dmenu
            "${cfg.modifier}+r" = "exec ${dmenu.exec}";


            # layout handling
            "${cfg.modifier}+b" = "splith";
            "${cfg.modifier}+v" = "splitv";
            "${cfg.modifier}+o" = "layout stacking";
            "${cfg.modifier}+i" = "layout tabbed";
            "${cfg.modifier}+h" = "layout toggle split";
            "${cfg.modifier}+f" = "fullscreen";

            # sway specific
            "${cfg.modifier}+Shift+q" = "kill";
            "${cfg.modifier}+Shift+c" = "reload";
            "${cfg.modifier}+Mod1+Shift+c" = "restart";

            # mode triggers
            "${cfg.modifier}+Shift+r" = "mode resize";
            "${cfg.modifier}+Delete" = ''mode "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown"'';
          };

          colors = let inherit (config.kw.theme) base16; in
            {
              focused = {
                border = base16.base01;
                background = base16.base0D;
                text = base16.base07;
                indicator = base16.base0D;
                childBorder = base16.base0D;
              };
              focusedInactive = {
                border = base16.base02;
                background = base16.base04;
                text = base16.base00;
                indicator = base16.base04;
                childBorder = base16.base04;
              };
              unfocused = {
                border = base16.base01;
                background = base16.base02;
                text = base16.base06;
                indicator = base16.base02;
                childBorder = base16.base02;
              };
              urgent = {
                border = base16.base03;
                background = base16.base08;
                text = base16.base00;
                indicator = base16.base08;
                childBorder = base16.base08;
              };
            };
          };
      extraConfig = ''
        title_align center
        set $mode_gaps Gaps: (o) outer, (i) inner
        set $mode_gaps_outer Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)
        set $mode_gaps_inner Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)
        bindsym ${cfg.modifier}+Shift+g mode "$mode_gaps"

        mode "$mode_gaps" {
        bindsym o      mode "$mode_gaps_outer"
        bindsym i      mode "$mode_gaps_inner"
        bindsym Return mode "default"
        bindsym Escape mode "default"
        }

        mode "$mode_gaps_inner" {
        bindsym equal  gaps inner current plus 5
        bindsym minus gaps inner current minus 5
        bindsym 0     gaps inner current set 0

        bindsym plus  gaps inner all plus 5
        bindsym Shift+minus gaps inner all minus 5
        bindsym Shift+0     gaps inner all set 0

        bindsym Return mode "default"
        bindsym Escape mode "default"
        }

        mode "$mode_gaps_outer" {
        bindsym equal  gaps outer current plus 5
        bindsym minus gaps outer current minus 5
        bindsym 0     gaps outer current set 0

        bindsym plus  gaps outer all plus 5
        bindsym Shift+minus gaps outer all minus 5
        bindsym Shift+0     gaps outer all set 0

        bindsym Return mode "default"
        bindsym Escape mode "default"
        }
        ${workspaceBindingsStr}
      '';
    };
}
