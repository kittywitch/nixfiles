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
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
      extraConfig = ''
        workspace 1 output DP-2
        workspace 11 output HDMI-0
      '';
    config = let
      modifier = "Mod4";
      other_modifier = "Mod1";
      mod = modifier;
      mod2 = other_modifier;
      workspaceNames = {
        "1" = "";
        "2" = "";
        "11" = "";
        "12" = "";
        "13" = "";
      };
      workspaceNamer = num: let
        numStr = builtins.toString num;
    in if numStr ? workspaceNames then "${numStr}:${numStr} ${workspaceNames.numStr}" else "${numStr}:${numStr}";
    in {
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
        "${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
        "${mod}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";
        "${mod}+Return" = "exec ${config.programs.wezterm.package}/bin/wezterm";
        "${mod}+Tab" = "workspace back_and_forth";
        "${mod}+Shift+Tab" = "exec ${config.services.i3gopher.focus-last}";
      };
      in mkMerge (map mapDefaultAttrs ([ normalBindings  ] ++ workspaceBindings));
      assigns = {
        ${workspaceNamer 2} = [
          {
            class = "^steam_app_default$";
          }
        ];
        ${workspaceNamer 13} = [
          {
            class = "^Spotify$";
          }
        ];
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
        background = "$base";
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
            background = "$base";
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
