{ config, pkgs, lib, ... }:

let colors = import ./colors.nix;
in {
  config = lib.mkIf (lib.elem "sway" config.meta.deploy.profiles) {
    fonts.fonts = with pkgs; [
      font-awesome
      nerdfonts
      iosevka
      emacs-all-the-icons-fonts
    ];
    users.users.kat.packages = with pkgs; [ grim slurp ];
    programs.sway.enable = true;

    systemd.user.services.mako = {
      serviceConfig.ExecStart = "${pkgs.mako}/bin/mako";
      restartTriggers =
        [ config.home-manager.users.kat.xdg.configFile."mako/config".source ];
    };

    home-manager.users.kat = {
      programs.kitty = {
        enable = true;
        font.name = "Hack Nerd Font";
        settings = {
          font_size = "10.0";
          background = colors.black;
          foreground = colors.white;
          background_opacity = "0.8";
          selection_background = colors.white;
          selection_foreground = colors.black;
          url_color = colors.yellow;
          cursor = colors.white;
          active_border_color = "#75715e";
          active_tab_background = "#9900ff";
          active_tab_foreground = colors.white;
          inactive_tab_background = "#3a3a3a";
          inactive_tab_foreground = "#665577";
        } // colors.base16;
      };

      programs.mako = {
        enable = true;
        defaultTimeout = 3000;
        borderColor = colors.white;
        backgroundColor = "${colors.black}70";
        textColor = colors.white;
      };

      wayland.windowManager.sway = {
        enable = true;
        config = let
          dmenu =
            "${pkgs.bemenu}/bin/bemenu --fn 'Iosevka 12' --nb '${colors.black}' --nf '${colors.white}' --sb '${colors.red}' --sf '${colors.white}' -l 5 -m -1 -i";
          lockCommand = "swaylock -i ${./middle.jpg} -s fill";
          cfg = config.home-manager.users.kat.wayland.windowManager.sway.config;
        in {
          bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

          output = let
            left = {
              res = "1920x1080";
              pos = "0 0";
              bg = "${./left.jpg} fill";
            };
            middle = {
              res = "1920x1080";
              pos = "1920 0";
              bg = "${./middle.jpg} fill";
            };
            right = {
              res = "1920x1080";
              pos = "3840 0";
              bg = "${./right.jpg} fill";
            };
            laptop = {
              res = "1920x1080";
              pos = "0 0";
              bg = "${./laptop.jpg} fill";
            };
          in {
            "DP-1" = left;
            "DVI-D-1" = middle;
            "HDMI-A-1" = right;
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

          fonts = [ "Hack Nerd Font 10" ];
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
            "${cfg.modifier}+Print" =
              "exec ${pkgs.bash}/bin/bash -c '~/.local/bin/elixiremanager.sh -w'";

            "${cfg.modifier}+d" = "exec ${cfg.menu}";
            "${cfg.modifier}+x" = "exec ${lockCommand}";

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

          #   keycodebindings = {
          #     "--no-repeat 107" = "exec dbus-send --session --type=method_call --dest=net.sourceforge.mumble.mumble / net.sourceforge.mumble.Mumble.startTalking";
          #     "--release 107" = "exec dbus-send --session --type=method_call --dest=net.sourceforge.mumble.mumble / net.sourceforge.mumble.Mumble.stopTalking";
          #   };

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
              border = colors.bright.black;
              background = colors.yellow;
              text = colors.black;
              indicator = colors.green;
              childBorder = colors.bright.black;
            };
            focusedInactive = {
              border = colors.bright.black;
              background = colors.bright.green;
              text = colors.black;
              indicator = colors.green;
              childBorder = colors.bright.black;
            };
            unfocused = {
              border = colors.bright.black;
              background = colors.black;
              text = colors.bright.black;
              indicator = colors.bright.black;
              childBorder = colors.bright.black;
            };
            urgent = {
              border = colors.bright.black;
              background = colors.bright.red;
              text = colors.black;
              indicator = colors.red;
              childBorder = colors.bright.black;
            };
          };
        };
        wrapperFeatures.gtk = true;
        extraConfig = ''
          seat seat0 xcursor_theme breeze_cursors 20
        '';
      };
      programs.waybar = {
        enable = true;
        #       style = ''
        #         * {
        #           font-family: "Iosevka";
        #         }
        #       '';
        settings = [{
          modules-left = [ "sway/workspaces" "sway/mode" ];
          modules-center = [ "sway/window" ];
          modules-right = [
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "temperature"
            "clock"
            "tray"
          ];

          modules = {
            pulseaudio = {
              format = "{volume}%";
              on-click = "pavucontrol";
            };
            network = {
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
              format-linked = "{ifname} (No IP) ";
              format-disconnected = "Disconnected ⚠";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
            };
            clock = { format = "{:%A, %F %T %Z}"; };
          };
        }];
      };
    };
  };
}
