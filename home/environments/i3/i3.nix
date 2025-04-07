{
pkgs,
lib,
std,
config,
...
}:
let
  inherit (std) list;
  inherit (lib.modules) mkMerge;
  inherit (lib) mkOptionDefault mkDefault mapAttrs;
in {
  home.packages = with pkgs; [
    maim
    pcmanfm
    pavucontrol
    xclip
  ];
  services.i3gopher.enable = true;
  xsession.windowManager.i3 = let
      modifier = "Mod4";
      other_modifier = "Mod1";
      mod = modifier;
      mod2 = other_modifier;
      runCommand = "${config.programs.rofi.finalPackage}/bin/rofi -show combi -modes combi";
      workspaceNames = {
        "1" = " Term";
        "2" = " GW2";
        "3" = " GW1";
        "4" = " Web";
        "11" = " IM";
        "12" = " Web";
        "13" = " Media";
        "14" = " Music";
      };
      workspaceNamer = num: let
        numStr = builtins.toString num;
      in if workspaceNames ? ${numStr} then "${numStr}:${workspaceNames.${numStr}}" else "${numStr}:${numStr}";

      lockCommand = "sh -c '${pkgs.i3lock-fancy-rapid}/bin/i3lock 5 3 & sleep 5 && xset dpms force off'";

      actionMode = "(l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown";
      gapsMode = "Gaps: (o) outer, (i) inner";
      gapsOuterMode = "Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)";
      gapsInnerMode = "Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)";
    in {
    enable = true;
    extraConfig = ''
      workspace 1 output DP-2 gaps inner 10
      workspace 2 output DP-2
      workspace 3 output DP-2
      workspace 4 output DP-2
      workspace 5 output DP-2
      workspace 5 output DP-2
      workspace 6 output DP-2
      workspace 7 output DP-2
      workspace 8 output DP-2
      workspace 9 output DP-2
      workspace 0 output DP-2
      workspace 11 output HDMI-0
      workspace 12 output HDMI-0
      workspace 13 output HDMI-0
      workspace 14 output HDMI-0
      workspace 15 output HDMI-0
      workspace 16 output HDMI-0
      workspace 17 output HDMI-0
      workspace 18 output HDMI-0
      workspace 19 output HDMI-0
      workspace 20 output HDMI-0
      for_window [class="^steam_app_default$"] floating enable
    '';
    config = {
      inherit modifier;
      fonts = {
        size = 10.0;
        style = "Regular";
        names = [
          "Monaspace Krypton"
          "FontAwesome 6"
        ];
      };

      startup = [
        { command = "~/.screenlayout/main.sh"; }
        { command = "blueman-applet"; }
      ];

      keybindings = let
        bindWorkspace = key: workspace: {
          "${mod}+${key}" = "workspace number ${workspaceNamer workspace}";
          "${mod}+shift+${key}" = "move container to workspace number ${workspaceNamer workspace}";
        };
        mapDefaultAttrs = e: mapAttrs (_: mkDefault) e;
        workspaceBindings =
          list.map (v: bindWorkspace v "${v}") (list.map builtins.toString (list.range 1 9))
          ++ [
            (
              bindWorkspace "0" "10"
            )
          ]
          ++ list.imap (i: v: bindWorkspace v "${toString (11 + i)}") (list.map (n: "F${builtins.toString n}") (std.list.range 1 12));
        normalBindings = {
          "Print" = "exec --no-startup-id maim \"/home/$USER/Pictures/$(date).png\"";
          "${mod2}+Print" = "exec --no-startup-id maim --window $(xdotool getactivewindow) \"/home/$USER/Pictures/Screenshots/$(date).png\"";
          "Shift+Print" = "exec --no-startup-id maim --select \"/home/$USER/Pictures/Screenshots/$(date).png\"";

          "Ctrl+Print" = "exec --no-startup-id maim | xclip -selection clipboard -t image/png";
          "Ctrl+${mod2}+Print" = "exec --no-startup-id maim --window $(xdotool getactivewindow) | xclip -selection clipboard -t image/png";
          "Ctrl+Shift+Print" = "exec --no-startup-id maim --select | xclip -selection clipboard -t image/png";

          "${mod}+r" = "exec ${runCommand}";
          "${mod}+p" = "mode resize";
          "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
          "${mod}+Shift+x" = "exec ${lockCommand}";
          "${mod}+Return" = "exec ${config.programs.wezterm.package}/bin/wezterm";
          "${mod}+Tab" = "workspace back_and_forth";
          "${mod}+Shift+Tab" = "exec ${config.services.i3gopher.focus-last}";
          "${mod}+Shift+g" = ''mode "${gapsMode}"'';
          "${mod}+Delete" = ''mode "${actionMode}"'';
        };
      in mkMerge (map mapDefaultAttrs ([ normalBindings  ] ++ workspaceBindings));

      assigns = {
        ${workspaceNamer 2} = [
          {
            class = "^steam_app_default$";
            title = "^Guild Wars 2$";
          }
        ];
        ${workspaceNamer 3} = [
          {
            class = "^steam_app_default$";
            title = "^Guild Wars$";
          }
        ];
        ${workspaceNamer 11} = [
          {
            class = "^Discord$";
          }
        ];
        ${workspaceNamer 13} = [
          {
            class = "^mpv$";
          }
        ];
        ${workspaceNamer 14} = [
          {
            class = "^Spotify$";
          }
        ];
      };
      modes = let
        defaultPath = {
          "Return" = "mode default";
          "Escape" = "mode default";
          "${mod}+z" = "mode default";
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
            "o" = ''mode "${gapsOuterMode}"'';
            "i" = ''mode "${gapsInnerMode}"'';
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
      workspaceAutoBackAndForth = true;

      colors = {
        focused = {
          border = "$lavender";
          background = "$base";
          text = "$text";
          indicator = "$rosewater";
          childBorder = "$lavender";
        };
        focusedInactive = {
          border = "$overlay0";
          background = "$base";
          text = "$text";
          indicator = "$rosewater";
          childBorder = "$overlay0";
        };
        unfocused = {
          border = "$overlay0";
          background = "$base";
          text = "$text";
          indicator = "$rosewater";
          childBorder = "$overlay0";
        };
        urgent = {
          border = "$peach";
          background = "$base";
          text = "$peach";
          indicator = "$overlay0";
          childBorder = "$peach";
        };
        placeholder = {
          border = "$overlay0";
          background = "$base";
          text = "$text";
          indicator = "$overlay0";
          childBorder = "$overlay0";
        };
        background = "$base00";
      };

      bars = [
        {
          # as if anyone was questioning that,
          position = "bottom";
          fonts = {
            names = [
              "Monaspace Krypton"
              "FontAwesome 6 Free"
              "FontAwesome 6 Brands"
            ];
            size = 10.0;
          };
          colors = {
            background = "$base00";
            statusline = "$text";
            separator = "$text";
            focusedBackground = "$base";
            focusedStatusline = "$text";
            focusedSeparator = "$base";
            focusedWorkspace = {
              border ="$base";
              background = "$mauve";
              text = "$crust";
            };
            activeWorkspace = {
              border = "$base";
              background = "$surface2";
              text = "$text";
            };
            inactiveWorkspace = {
              border = "$base";
              background = "$base";
              text = "$text";
            };
            urgentWorkspace = {
              border = "$base";
              background = "$red";
              text = "$crust";
            };
          };
          trayOutput = "primary";
          extraConfig = ''
            strip_workspace_numbers yes
          '';
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-gaybar.toml";
        }
      ];
    };
  };
}
