{ config, pkgs, lib, witch, ... }:

{
  config = lib.mkIf config.deploy.profile.sway {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
    };

    home.packages = with pkgs; [ grim slurp wl-clipboard jq ];

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

    wayland.windowManager.sway = let
      cfg = config.wayland.windowManager.sway.config;
      bindsym = k: v: "bindsym ${k} ${v}";
      bindWorkspace = key: workspace: {
        "${cfg.modifier}+${key}" = "workspace number ${workspace}";
        "${cfg.modifier}+shift+${key}" =
          "move container to workspace number ${workspace}";
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
      ] ++ [ (bindWorkspace "0" "10:10") ]
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
      workspaceBindingsStr =
        lib.concatStringsSep "\n" (lib.flatten workspaceBindings');
    in {
      enable = true;
      config = let
        dmenu =
          "${pkgs.bemenu}/bin/bemenu --fn '${witch.style.font.name} ${witch.style.font.size}' --nb '${witch.style.base16.color0}' --nf '${witch.style.base16.color7}' --sb '${witch.style.base16.color1}' --sf '${witch.style.base16.color7}' -l 5 -m -1 -i";
        lockCommand = "swaylock -i eDP-1:${
            ../../../private/files/wallpapers/main.png
          } -i HDMI-A-1:${../../../private/files/wallpapers/main.png} -i DP-1:${
            ../../../private/files/wallpapers/left.jpg
          }  -i DVI-D-1:${../../../private/files/wallpapers/right.jpg} -s fill";

      in {
        bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

        output = let
          left = {
            res = "1920x1080";
            pos = "0 0";
            bg = "${../../../private/files/wallpapers/left.jpg} fill";
          };
          middle = {
            res = "1920x1080";
            pos = "1920 0";
            bg = "${../../../private/files/wallpapers/main.png} fill";
          };
          right = {
            res = "1920x1080";
            pos = "3840 0";
            bg = "${../../../private/files/wallpapers/right.jpg}  fill";
          };
          laptop = {
            res = "1920x1080";
            pos = "0 0";
            bg = "${../../../private/files/wallpapers/main.png} fill";
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
          "5824:1503:screenstub-tablet" = { events = "disabled"; };
          "5824:1503:screenstub-mouse" = { events = "disabled"; };
          "5824:1503:screenstub-kbd" = { events = "disabled"; };
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

        assigns = { "F1" = [{ class = "screenstub"; }]; };
        startup = [
          {
            command = "systemctl --user restart mako";
            always = true;
          }
          { command = "${pkgs.i3gopher}/bin/i3gopher"; }
          { command = "mkchromecast -t"; }
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

          "${cfg.modifier}+Tab" = "workspace back_and_forth";
          "${cfg.modifier}+Shift+Tab" =
            "${pkgs.i3gopher}/bin/i3gopher --focus-last";
          "${cfg.modifier}+Ctrl+Left" = "workspace prev_on_output";
          "${cfg.modifier}+Ctrl+Right" = "workspace next_on_output";

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
            "exec ${pkgs.kat-scrot}/bin/kat-scrot --notify upload screen";
          "${cfg.modifier}+Shift+Print" =
            "exec ${pkgs.kat-scrot}/bin/kat-scrot  --notify upload area";
          "${cfg.modifier}+Mod1+Print" =
            "exec ${pkgs.kat-scrot}/bin/kat-scrot --notify upload window";
          "Print" = "exec ${pkgs.kat-scrot}/bin/kat-scrot --notify save screen";
          "Shift+Print" =
            "exec ${pkgs.kat-scrot}/bin/kat-scrot  --notify save area";
          "Mod1+Print" =
            "exec ${pkgs.kat-scrot}/bin/kat-scrot --notify save window";

          "${cfg.modifier}+i" = "move workspace to output left";
          "${cfg.modifier}+o" = "move workspace to output right";
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
        workspace "1" output "DP-1"
        workspace "F2" output "DVI-D-1"
        workspace "F1" output "HDMI-A-1"
        workspace_auto_back_and_forth yes
        ${workspaceBindingsStr}
      '';
    };
  };

}
