{
  config,
  pkgs,
  lib,
  ...
}: let
  # TODO: fix use of lib
  lockCommand = config.programs.swaylock.script;
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
    ] ++ [(
      bindWorkspace "0" "10:10")
    ] ++ lib.imap1 (i: v: bindWorkspace v "${toString (10 + i)}:${v}") [
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

  in {
    enable = true;
    config = let
      pactl = "${config.home.nixosConfig.hardware.pulseaudio.package or pkgs.pulseaudio}/bin/pactl";
      dmenu = "${pkgs.wofi}/bin/wofi -idbt ${pkgs.wezterm}/bin/wezterm -s ~/.config/wofi/wofi.css -p '' -W 25%";
    in {
      modes = {
        "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown" = {
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

      bars = [];

      input = {
        "*" = {
          xkb_layout = "us_gbp_map";
          xkb_options = "compose:rctrl,ctrl:nocaps";
        };
      };

      fonts = {
        names = [ "Iosevka Comfy"];
        style = "Regular";
        size = 10.0;
      };

      terminal = "${pkgs.wezterm}/bin/wezterm";
      menu = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --no-generic --dmenu=\"${dmenu}\" --term='${pkgs.wezterm}/bin/wezterm'";

      modifier = "Mod4";

      startup = [
        { command = "gsettings set org.gnome.desktop.interface cursor-theme 'Quintom_Snow'"; }
        {
          command = "systemctl --user restart mako";
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
      };

      floating = {
        border = 1;
        titlebar = false;
      };

      keybindings = {
        "${cfg.modifier}+Return" = "exec ${cfg.terminal}";
        "${cfg.modifier}+x" = "exec ${lockCommand}";

        # focus windows - regular
        "${cfg.modifier}+Left" = "focus left";
        "${cfg.modifier}+Down" = "focus down";
        "${cfg.modifier}+Up" = "focus up";
        "${cfg.modifier}+Right" = "focus right";

        # move window / container - regular
        "${cfg.modifier}+Shift+Left" = "move left";
        "${cfg.modifier}+Shift+Down" = "move down";
        "${cfg.modifier}+Shift+Up" = "move up";
        "${cfg.modifier}+Shift+Right" = "move right";

        # focus output - regular
        "${cfg.modifier}+control+Left" = "focus output left";
        "${cfg.modifier}+control+Down" = "focus output down";
        "${cfg.modifier}+control+Up" = "focus output up";
        "${cfg.modifier}+control+Right" = "focus output right";

        # move container to output - regular
        "${cfg.modifier}+control+Shift+Left" = "move container to output left";
        "${cfg.modifier}+control+Shift+Down" = "move container to output down";
        "${cfg.modifier}+control+Shift+Up" = "move container to output up";
        "${cfg.modifier}+control+Shift+Right" = "move container to output right";

        # move workspace to output - regular
        "${cfg.modifier}+control+Shift+Mod1+Left" = "move workspace to output left";
        "${cfg.modifier}+control+Shift+Mod1+Down" = "move workspace to output down";
        "${cfg.modifier}+control+Shift+Mod1+Up" = "move workspace to output up";
        "${cfg.modifier}+control+Shift+Mod1+Right" = "move workspace to output right";

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
        "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioLowerVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioRaiseVolume" = "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioMute" = "exec --no-startup-id ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMute+Shift" = "exec --no-startup-id ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86AudioMicMute" = "exec --no-startup-id ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
        "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";

        # dmenu
        "${cfg.modifier}+r" = "exec ${cfg.menu}";

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

        # mode triggers
        "${cfg.modifier}+Shift+r" = "mode resize";
        "${cfg.modifier}+Delete" = ''mode "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown"'';
      };

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
    };

    wrapperFeatures.gtk = true;

    extraConfig = ''
      hide_edge_borders smart_no_gaps
      smart_borders no_gaps
      title_align center
      seat seat0 xcursor_theme Quintom_Snow 20
      workspace_auto_back_and_forth yes
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
