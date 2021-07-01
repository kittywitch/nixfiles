{ config, lib, pkgs, witch, ... }:

let
  base16 = lib.mapAttrs' (k: v: lib.nameValuePair k "#${v.hex.rgb}")
    config.lib.arc.base16.schemeForAlias.default;
  font = {
    name = "Iosevka Nerd Font";
    size = "10";
    size_css = "12px";
  };
in
{
  config = lib.mkIf config.deploy.profile.sway {
    programs.waybar = {
      enable = true;
      style = import ./waybar.css.nix {
        inherit font base16;
        inherit (pkgs) hextorgba;
      };
      settings = [{
        modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
        modules-center = [ ]; # "clock" "custom/weather"
        modules-right = [
          "pulseaudio"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "battery"
          #"mpd"
          "network"
          "custom/gpg-status"
          #"custom/weather"
          "clock"
          "idle_inhibitor"
          "tray"
        ];

        modules = {
          "sway/workspaces" = { format = "{name}"; };
          #"custom/weather" = {
          #  format = "{}";
          #  interval = 3600;
          #  on-click = "xdg-open 'https://google.com/search?q=weather'";
          #  exec =
          #    "${pkgs.kat-weather}/bin/kat-weather ${witch.secrets.profiles.sway.city} ${witch.secrets.profiles.sway.api_key}";
          #};
          "custom/gpg-status" = {
            format = "{}";
            interval = 300;
            exec = "${pkgs.kat-gpg-status}/bin/kat-gpg-status";
          };
          cpu = { format = " {usage}%"; };
          #mpd = { 
          #  format = "  {albumArtist} - {title}"; 
          #  format-stopped = "ﱙ";
          #  format-paused = "  Paused";
          #  title-len = 16;
          #};
          memory = { format = " {percentage}%"; };
          temperature = { format = "﨎{temperatureC}°C"; };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
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
            format = "{icon} {capacity}%";
            format-charging = "  {capacity}%";
            format-plugged = "  {capacity}%";
            format-alt = "{icon}  {time}";
            format-icons = [ "" "" "" "" "" ];
          };
          pulseaudio = {
            format = " {volume}%";
            on-click = "pavucontrol";
          };
          network = {
            format-wifi = "";
            format-ethernet = "";
            format-linked = "  {ifname} (No IP)";
            format-disconnected = "  Disconnected ";
            format-alt = "  {ifname}: {ipaddr}/{cidr}";
            tooltip-format-wifi = "{essid} ({signalStrength}%)";
          };
          clock = {
            format = " {:%T %z}";
            tooltip = true;
            tooltip-format = "{:%A, %F %T %z (%Z)}";
            timezones = [
              "Europe/London"
              "America/Vancouver"
              "America/Chicago"
              "Europe/Berlin"
              "Pacific/Auckland"
            ];
            interval = 1;
          };
        };
      }];
    };
  };
}
