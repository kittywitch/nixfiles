{
  kittywitch,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  systemd.user.services.waybar = {
    Install.WantedBy = lib.mkForce ["hyprland-session.target"];
    Service = {
      RestartSec = "1s";
    };
    Unit = {
      After = ["hyprland-session.target"];
      X-Restart-Triggers = [
        (builtins.hashString "md5" (builtins.toJSON config.programs.waybar.settings))
      ];
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = let
      template = kittywitch.sassTemplate {
        name = "waybar-style";
        src = ./waybar.sass;
      };
    in
      template.source;
    settings.main = {
      layer = "top";
      position = "top";
      height = 24;

      # Modules Placement
      modules-left = [
        "hyprland/workspaces"
        "hyprland/submap"
        "hyprland/window"
      ];
      modules-right = [
        "idle_inhibitor"
        "power-profiles-daemon"
        "tray"
        "battery"
        "clock"
      ];

      # Modules Definition
      "hyprland/workspaces" = {
        format = "{icon}";
        /*
          format-icons = {
          # https://fontawesome.com/v5/cheatsheet
          "1" = ""; # chats
          "2" = ""; # cloud (browser)
          "3" = ""; # music
          "4" = ""; # brain
          "5" = ""; # terminal >_
        };
        */
      };
      "hyprland/window" = {
        format = "{}";
        rewrite = {
          "(.*) — Mozilla Firefox" = "🌎 $1";
          "(.*) - fish" = "> [$1]";
        };
      };
      tray = {
        show-passive-items = true;
        icon-size = 24;
        spacing = 2;
      };
      power-profiles-daemon = {
        format = "{profile}";
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        tooltip = true;
      };
      mpris = {
        format = "{player_icon} {dynamic}";
        format-paused = "{status_icon} {dynamic}";
        player-icons = {
          default = "";
          brave = "";
          mpv = "";
          spotify = "";
        };
        status-icons = {
          paused = "";
        };
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };
      clock = {
        format = "{:%F %H:%M %Z}";
      };
    };
  };
}
