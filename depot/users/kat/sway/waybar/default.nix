{ config, lib, pkgs, ... }:

let
  base16 = lib.mapAttrs' (k: v: lib.nameValuePair k "#${v.hex.rgb}")
  config.lib.arc.base16.schemeForAlias.default;
in
  {
    programs.waybar = {
      enable = true;
      style = import ./waybar.css.nix {
        inherit  base16;
        inherit (lib) hextorgba;
        font = config.kw.font;
      };
      settings = [{
        modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
        modules-center = ["clock" "clock#arc" "clock#miku" "clock#hex" ]; # "clock" "custom/weather"
        modules-right = [
          "pulseaudio"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "battery"
          #"mpd"
          "network"
          #"custom/weather"
          "idle_inhibitor"
          "custom/konawall"
          "custom/gpg-status"
          "tray"
        ];

        modules = {
          "sway/workspaces" = { format = "{name}"; };
          "sway/window" = {
            format = " {}";
            max-length = 50;
          };
          #"custom/weather" = {
          #  format = "{}";
          #  interval = 3600;
          #  on-click = "xdg-open 'https://google.com/search?q=weather'";
          #  exec =
          #    "${pkgs.kat-weather}/bin/kat-weather ${witch.secrets.profiles.sway.city} ${witch.secrets.profiles.sway.api_key}";
          #};
          tray = {
            icon-size = 12;
            spacing = 2;
          };
          "custom/gpg-status" = {
            format = " {}";
            interval = 300;
            return-type = "json";
            exec = "${pkgs.kat-gpg-status}/bin/kat-gpg-status";
          };
          "custom/konawall" = {
            format = "  {}";
            interval = "once";
            return-type = "json";
            exec = "${pkgs.konawall-toggle}/bin/konawall-status";
            exec-on-event = true;
            on-click = "${pkgs.konawall-toggle}/bin/konawall-toggle";
            on-click-right = "systemctl --user restart konawall";
          };
          cpu = { format = " {usage}%"; };
          #mpd = { 
          #  format = "  {albumArtist} - {title}"; 
          #  format-stopped = "ﱙ";
          #  format-paused = "  Paused";
          #  title-len = 16;
          #};
          memory = { format = " {percentage}%"; };
          temperature = {
            format = " {temperatureC}°C";
            hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp2_input";
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          backlight = {
            format = "BL {percent}%";
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
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-alt = "{icon} {time}";
            format-icons = [ "" "" "" "" "" ];
          };
          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "婢";
            on-click = "foot pulsemixer";
            format-icons = {
              default = [
                ""
                ""
                ""
              ];
            };
          };
          network = {
            format-wifi = "直";
            format-ethernet = " {ifname}";
            format-linked = " {ifname} (NO IP)";
            format-disconnected = " DC";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            tooltip-format-wifi = "{essid} ({signalStrength}%)";
          };
          clock = {
            format = "{:%a, %F %T}";
            tooltip = true;
            tooltip-format = "{:%A, %F %T %z (%Z)}";
            timezones = [
              "Europe/London"
              "America/Vancouver"
              "Europe/Berlin"
              "Pacific/Auckland"
            ];
            interval = 1;
          };
          "clock#arc" = {
            format = "♡-{:%H}";
            tooltip = true;
            timezone = "America/Vancouver";
            tooltip-format = "{:%A, %F %R %z (%Z)}";
          };
          "clock#miku" = {
            format = "♡+{:%H}";
            tooltip = true;
            timezone = "Pacific/Auckland";
            tooltip-format = "{:%A, %F %R %z (%Z)}";
          };
          "clock#hex" = {
            format = "♡+{:%H}";
            tooltip = true;
            timezone = "Europe/Berlin";
            tooltip-format = "{:%A, %F %R %z (%Z)}";
          };
        };
      }];
    };
  }
