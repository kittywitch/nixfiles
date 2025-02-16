{
  kittywitch,
  pkgs,
  ...
}: {
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
      height = 18;

      # Modules Placement
      modules-left = [
        "sway/workspaces"
        "sway/mode"
        "sway/window"
      ];
      modules-center = [
        "custom/clock"
        "mpris"
      ];
      modules-right = [
        "network"
        "temperature"
        "idle_inhibitor"
        "battery"
        "tray"
      ];

      # Modules Definition
      "sway/workspaces" = {
        format = "{icon}";
        format-icons = {
          # https://fontawesome.com/v5/cheatsheet
          "1" = ""; # chats
          "2" = ""; # cloud (browser)
          "3" = ""; # music
          "4" = ""; # brain
          "5" = ""; # terminal >_
        };
      };
      "sway/window" = {
        format = "{}";
      };
      battery = {};
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
      "custom/clock" = {
        exec = ''${pkgs.coreutils}/bin/date +"%a, %F %T %Z"'';
        interval = 1;
      };
    };
  };
}
