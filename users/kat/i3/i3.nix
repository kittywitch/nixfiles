{ config, base16, pkgs, lib, ... }: with lib;
let
          lockCmd = "${pkgs.i3lock}/bin/i3lock -nc 000000";
in {
  programs.zsh.loginExtra = ''
      if [[ -z "''${TMUX-}" && -z "''${DISPLAY-}" && "''${XDG_VTNR-}" = 1 && $(${pkgs.coreutils}/bin/id -u) != 0 ]]; then
        ${pkgs.xorg.xinit}/bin/startx
      fi
  '';

  services = {
    i3gopher.enable = true;
    screen-locker = {
      enable = true;
      inherit lockCmd;
      xautolock.enable = true;
    };
  };

  home.file.".xinitrc".text = ''
    exec ~/.xsession
  '';

  xsession = {
    enable = true;
    windowManager.i3 =
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
      in
      {
        enable = true;
        package = pkgs.i3-gaps;
        config =
          let
            pactl = "${config.home.nixos.hardware.pulseaudio.package or pkgs.pulseaudio}/bin/pactl";
          #dmenu = "${pkgs.wofi}/bin/wofi -idbt ${pkgs.kitty}/bin/kitty -s ~/.config/wofi/wofi.css -p '' -W 25%";
          dmenu = pkgs.writeShellScriptBin "rofi-wrap" ''${pkgs.rofi}/bin/rofi -combi-modi window,drun,ssh -show combi'';
          in
          {

            modes = {
              "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown" =
                {
                  "l" = "exec ${lockCmd}, mode default";
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
            "${cfg.modifier}+x" = "exec ${lockCmd}";

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
    };
  }
