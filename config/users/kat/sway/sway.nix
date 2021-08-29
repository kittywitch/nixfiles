{ config, pkgs, lib, witch, ... }:

let
  footwrap = pkgs.writeShellScriptBin "footwrap" ''
    exec foot "$2"
  '';
  lockCommand =
    let
      base16 = lib.mapAttrs' (k: v: lib.nameValuePair k (lib.removePrefix "#" v)) config.kw.theme.base16;
      # TODO: integrate into /config/modules/home/theme.nix
      # thank you to @u1f408 💜
    in
    ''
      ${pkgs.swaylock-effects}/bin/swaylock \
        --screenshots \
        --indicator \
        --indicator-radius 110 \
        --indicator-thickness 8 \
        --font ${config.kw.theme.font.name} \
        --font-size ${toString config.kw.theme.font.size} \
        --clock --timestr '%H:%M:%S' --datestr '%Y-%m-%d' \
        --effect-blur 3x2 \
        --fade-in 0.2 \
        --key-hl-color ${base16.base0C} \
        --separator-color ${base16.base01} \
        --line-color ${base16.base01} \
        --line-clear-color ${base16.base01} \
        --line-caps-lock-color ${base16.base01} \
        --line-ver-color ${base16.base01} \
        --line-wrong-color ${base16.base01} \
        --ring-color ${base16.base00} \
        --ring-clear-color ${base16.base0B} \
        --ring-caps-lock-color ${base16.base09} \
        --ring-ver-color ${base16.base0D} \
        --ring-wrong-color ${base16.base08} \
        --inside-color ${base16.base00} \
        --inside-clear-color ${base16.base00} \
        --inside-caps-lock-color ${base16.base00} \
        --inside-ver-color ${base16.base00} \
        --inside-wrong-color ${base16.base00} \
        --text-color ${base16.base05} \
        --text-clear-color ${base16.base05} \
        --text-caps-lock-color ${base16.base05} \
        --text-ver-color ${base16.base05} \
        --text-wrong-color ${base16.base05} \
    '';
in
{
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    WLR_DRM_DEVICES = "/dev/dri/card0";
  };

  home.packages = with pkgs; [ grim slurp swaylock-fancy wl-clipboard jq quintom-cursor-theme gsettings-desktop-schemas glib wofi wmctrl ];

  services.i3gopher = { enable = true; };

  systemd.user.services.swayidle = {
    Unit = {
      Description = "swayidle";
      Documentation = [ "man:swayidle(1)" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle -w \
        timeout 300 '${lockCommand}' \
        timeout 600 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
        before-sleep '${lockCommand}'
      '';
      RestartSec = 3;
      Restart = "always";
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
  };

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

  wayland.windowManager.sway =
    let
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
    in
    {
      enable = true;
      config =
        let
          pactl = "${config.home.nixosConfig.hardware.pulseaudio.package or pkgs.pulseaudio}/bin/pactl";
          dmenu = "${pkgs.wofi}/bin/wofi -idbt ${footwrap}/bin/footwrap -s ~/.config/wofi/wofi.css -p '' -W 25%";
        in
        {

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
          bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

          input = {
            "*" = {
              xkb_layout = "us_gbp_map";
              xkb_options = "compose:rctrl,ctrl:nocaps";
            };
          };
          fonts = {
            names = [ config.kw.theme.font.name ];
            style = "Medium";
            size = config.kw.theme.font.size;
          };
          terminal = "${pkgs.foot}/bin/foot";
          menu = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --no-generic --dmenu=\"${dmenu}\" --term='${footwrap}/bin/footwrap'";
          modifier = "Mod4";

          assigns = { "12:F2" = [{ class = "screenstub"; }]; };
          startup = [
            {
              command = "gsettings set org.gnome.desktop.interface cursor-theme 'Quintom_Snow'";
            }
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

            # focus windows - wsad
            "${cfg.modifier}+a" = "focus left";
            "${cfg.modifier}+s" = "focus down";
            "${cfg.modifier}+w" = "focus up";
            "${cfg.modifier}+d" = "focus right";

            # move window / container - regular
            "${cfg.modifier}+Shift+Left" = "move left";
            "${cfg.modifier}+Shift+Down" = "move down";
            "${cfg.modifier}+Shift+Up" = "move up";
            "${cfg.modifier}+Shift+Right" = "move right";

            # move window / container - wsad
            "${cfg.modifier}+Shift+a" = "move left";
            "${cfg.modifier}+Shift+s" = "move down";
            "${cfg.modifier}+Shift+w" = "move up";
            "${cfg.modifier}+Shift+d" = "move right";

            # focus output - regular
            "${cfg.modifier}+control+Left" = "focus output left";
            "${cfg.modifier}+control+Down" = "focus output down";
            "${cfg.modifier}+control+Up" = "focus output up";
            "${cfg.modifier}+control+Right" = "focus output right";

            # focus output - wsad
            "${cfg.modifier}+control+a" = "focus output left";
            "${cfg.modifier}+control+s" = "focus output down";
            "${cfg.modifier}+control+w" = "focus output up";
            "${cfg.modifier}+control+d" = "foVcus output right";

            # move container to output - regular
            "${cfg.modifier}+control+Shift+Left" = "move container to output left";
            "${cfg.modifier}+control+Shift+Down" = "move container to output down";
            "${cfg.modifier}+control+Shift+Up" = "move container to output up";
            "${cfg.modifier}+control+Shift+Right" = "move container to output right";

            # move container to output - wsad
            "${cfg.modifier}+control+Shift+a" = "move container to output left";
            "${cfg.modifier}+control+Shift+s" = "move container to output down";
            "${cfg.modifier}+control+Shift+w" = "move container to output up";
            "${cfg.modifier}+control+Shift+d" = "move container to output right";

            # move workspace to output - regular
            "${cfg.modifier}+control+Shift+Mod1+Left" = "move workspace to output left";
            "${cfg.modifier}+control+Shift+Mod1+Down" = "move workspace to output down";
            "${cfg.modifier}+control+Shift+Mod1+Up" = "move workspace to output up";
            "${cfg.modifier}+control+Shift+Mod1+Right" = "move workspace to output right";

            # move workspace to output - wsad
            "${cfg.modifier}+control+Shift+Mod1+a" = "move workspace to output left";
            "${cfg.modifier}+control+Shift+Mod1+s" = "move workspace to output down";
            "${cfg.modifier}+control+Shift+Mod1+w" = "move workspace to output up";
            "${cfg.modifier}+control+Shift+Mod1+d" = "move workspace to output right";

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
            "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
            "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";

            # dmenu
            "${cfg.modifier}+r" = "exec ${cfg.menu}";

            # screenshots - upload
            "${cfg.modifier}+Print" = "exec ${pkgs.sway-scrot}/bin/sway-scrot --notify upload screen";
            "${cfg.modifier}+Shift+Print" = "exec ${pkgs.sway-scrot}/bin/sway-scrot  --notify upload area";
            "${cfg.modifier}+Mod1+Print" = "exec ${pkgs.sway-scrot}/bin/sway-scrot --notify upload active";
            "${cfg.modifier}+Mod1+Control+Print" = "exec ${pkgs.sway-scrot}/bin/sway-scrot --notify upload window";
            "${cfg.modifier}+Control+Print" = "exec ${pkgs.sway-scrot}/bin/sway-scrot --notify upload output";

            # screenshots - clipboard
            "Print" = "exec ${pkgs.sway-scrot}/bin/sway-scrot --notify copys screen";
            "Shift+Print" = "exec ${pkgs.sway-scrot}/bin/sway-scrot  --notify copys area";
            "Mod1+Print" = "exec ${pkgs.sway-scrot}/bin/sway-scrot --notify copys active";
            "Mod1+Control+Print" = "exec ${pkgs.sway-scrot}/bin/sway-scrot --notify copys window";
            "Control+Print" = "exec ${pkgs.sway-scrot}/bin/sway-scrot --notify copys output";

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
