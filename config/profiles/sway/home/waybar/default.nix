{ config, lib, pkgs, witch, ... }:

{
  config = lib.mkIf config.deploy.profile.sway {
    programs.waybar = {
      enable = true;
      style = import ./waybar.css.nix {
        style = witch.style;
        hextorgba = witch.colorhelpers.hextorgba;
      };
      settings = [{
        modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
        modules-center = [ "clock" "custom/weather" ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "battery"
          "tray"
        ];

        modules = {
          #"custom/weather" = {
          #  format = "{}";
          #  interval = 3600;
          #  on-click = "xdg-open 'https://google.com/search?q=weather'";
          #  exec = "nix-shell --command 'python ${../../../../../scripts/weather/weather.py} ${witch.secrets.profiles.sway.city} ${witch.secrets.profiles.sway.api_key}' ${../../../../../scripts/weather}";
          #};
          "custom/weather" = {
            format = "{}";
            interval = 3600;
            on-click = "xdg-open 'https://google.com/search?q=weather'";
            exec = "${pkgs.kat-weather}/bin/kat-weather ${witch.secrets.profiles.sway.city} ${witch.secrets.profiles.sway.api_key}";
          };
          cpu = { format = "  {usage}%"; };
          memory = { format = "  {percentage}%"; };
          temperature = { format = "﨎 {temperatureC}°C"; };
          backlight = {
            format = "{icon} {percent}%";
            format-icons = [ "" "" ];
            on-scroll-up = "${pkgs.light}/bin/light -A 1";
            on-scroll-down = "${pkgs.light}/bin/light -U 1";
          };
          battery = {
            states = {
              good = 90;
              warning = 30;
              critical = 15;
            };
            format = "{icon}  {capacity}%";
            format-charging = "  {capacity}%";
            format-plugged = "  {capacity}%";
            format-alt = "{icon}  {time}";
            format-icons = [ "" "" "" "" "" ];
          };
          pulseaudio = {
            format = "  {volume}%";
            on-click = "pavucontrol";
          };
          network = {
            format-wifi = "  {essid} ({signalStrength}%)";
            format-ethernet = "  {ifname}: {ipaddr}/{cidr}";
            format-linked = "  {ifname} (No IP)";
            format-disconnected = "  Disconnected ";
            format-alt = "  {ifname}: {ipaddr}/{cidr}";
          };
          clock = {
            format = "  {:%A, %F %T %Z}";
            interval = 1;
          };
        };
      }];
    };
  };
}
