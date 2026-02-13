{
  lib,
  pkgs,
  ...
}: let
  rawVariables = [
            "DISPLAY"
            "WAYLAND_DISPLAY"
            "XDG_CURRENT_DESKTOP"
            "XDG_SESSION_TYPE"
            "NIXOS_OZONE_WL"
            "XCURSOR_THEME"
            "XCURSOR_SIZE"
  ];
  variables = lib.concatStringsSep " " rawVariables;
  rawExtraCommands = [
    "systemctl --user reset-failed"
    "systemctl --user start mango-session.target"
  ];
  extraCommands = lib.concatStringsSep " && " rawExtraCommands;
  systemdActivation = ''${pkgs.dbus}/bin/dbus-update-activation-environment --systemd ${variables}; ${extraCommands}'';
  autostart_sh = pkgs.writeShellScript "autostart.sh" ''
    ${systemdActivation}
  '';
in {
  config = {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          "modules/left" = [
            "ext/workspaces"
            "dwl/tags"
            "dwl/window"
          ];
          "modules/center" = [
          ];
          "modules/right" = [
            "clock"
          ];
          "ext/workspaces" = {
            "format" = "{icon}";
            "ignore-hidden" = true;
            "on-click" = "activate";
            "on-click-right" = "deactivate";
            "sort-by-id" = true;
          };
          "dwl/tags" = {
              "num-tags" = 9;
          };
          "dwl/window" = {
            format = "[{layout}] {title}";
            "max-length" = 50;
            rewrite = {
                 "(.*) - Mozilla Firefox" = "🌎 $1";
                 "(.*) - vim" = " $1";
                 "(.*) - zsh" = " [$1]";
            };
          };
          clock = {
            format = "%F %T %Z";
            interval = 1;
            "max-length" = 25;
          };
        };
      };
    };
    home.packages = with pkgs; [
      mangowc
      satty
      grim
      slurp
      grimshot
      xwayland-satellite
      foot
    ];
    xdg.configFile = {
      "mango/bind.conf".text = let
        mod = "SUPER";
      in ''
        bind=${mod},r,reload_config
        bind=${mod},Return,spawn,foot
      '';
      "mango/config.conf".text = ''
        cursor_size=24
        env=XCURSOR_SIZE,24
        env=GTK_IM_MODULE,fcitx
        env=QT_IM_MODULE,fcitx
        env=SDL_IM_MODULE,fcitx
        env=XMODIFIERS,@im=fcitx
        env=GLFW_IM_MODULE,ibus
        env=QT_QPA_PLATFORMTHEME,qt5ct
        env=QT_AUTO_SCREEN_SCALE_FACTOR,1
        env=QT_QPA_PLATFORM,Wayland;xcb
        env=QT_WAYLAND_FORCE_DPI,140
        source=./bind.conf
      '';
      "mango/autostart.sh" = {
        source = autostart_sh;
        executable = true;
      };
    };
    systemd.user.targets.mango-session = {
      Unit = {
        Description = "mango compositor session";
        Documentation = ["man:systemd.special(7)"];
        BindsTo = ["graphical-session.target"];
        Wants =
          [
            "graphical-session-pre.target"
          ];
        After = ["graphical-session-pre.target"];
      };
    };
  };
}
