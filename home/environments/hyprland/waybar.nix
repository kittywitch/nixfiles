{
  kittywitch,
  pkgs,
  config,
  ...
}: {
  systemd.user.services.waybar.Unit.X-Restart-Triggers = [
    (builtins.hashString "md5" (builtins.toJSON config.programs.waybar.settings))
  ];
  programs.waybar = {
    enable = true;
    style = let
      template = kittywitch.sassTemplate {
        name = "waybar-style";
        src = ./waybar.sass;
      };
    in
      template.source;
    systemd.enable = true;
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
        "network"
        "temperature"
        "idle_inhibitor"
        "tray"
        "battery"
        "clock"
      ];

      # Modules Definition
      "hyprland/workspaces" = {
        format = "{icon}";
        /*format-icons = {
          # https://fontawesome.com/v5/cheatsheet
          "1" = ""; # chats
          "2" = ""; # cloud (browser)
          "3" = ""; # music
          "4" = ""; # brain
          "5" = ""; # terminal >_
        };*/
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
        icon-size = 12;
        spacing = 2;
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
      temperature = {
        format = " {temperatureC}°C";
        critical-threshold = 80;
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };
      network = {
        format-wifi = " {essid} ({signalStrength}%)";
        format-ethernet = " {ipaddr}/{cidr}";
        format-linked = " No IP";
        format-disconnected = " Disconnected";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };
      clock = {
        format = "{:%F %H:%M %Z}";
      };
    };
  };
}
