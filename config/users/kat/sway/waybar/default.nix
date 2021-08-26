{ config, lib, pkgs, kw, ... }:

{
  xdg.configFile."waybar/style.css" = { inherit (kw.sassTemplate { name = "waybar-style"; src = ./waybar.sass; }) source; };

  programs.waybar = {
    enable = true;
    settings = [{
      modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
      modules-center = [ "clock" "clock#arc" "clock#miku" "clock#hex" ];
      modules-right = [
        "pulseaudio"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "network"
        "idle_inhibitor"
        "custom/konawall"
        "custom/gpg-status"
        "tray"
      ];

      modules = {
        "sway/workspaces" = { format = "{name}"; };
        "sway/window" = {
          format = " {}";
          max-length = 50;
        };
        tray = {
          icon-size = 12;
          spacing = 2;
        };
        "custom/gpg-status" = {
          format = "{}";
          interval = 300;
          return-type = "json";
          exec = "${pkgs.waybar-gpg}/bin/kat-gpg-status";
        };
        "custom/konawall" = {
          format = "{}";
          interval = "once";
          return-type = "json";
          exec = "${pkgs.waybar-konawall}/bin/konawall-status";
          exec-on-event = true;
          on-click = "${pkgs.waybar-konawall}/bin/konawall-toggle";
          on-click-right = "systemctl --user restart konawall";
        };
        cpu = { format = " {usage}%"; };
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
          format-ethernet = "";
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
          format = "♥-{:%H}";
          tooltip = true;
          timezone = "America/Vancouver";
          tooltip-format = "{:%A, %F %R %z (%Z)}";
        };
        "clock#miku" = {
          format = "♥+{:%H}";
          tooltip = true;
          timezone = "Pacific/Auckland";
          tooltip-format = "{:%A, %F %R %z (%Z)}";
        };
        "clock#hex" = {
          format = "♥+{:%H}";
          tooltip = true;
          timezone = "Europe/Berlin";
          tooltip-format = "{:%A, %F %R %z (%Z)}";
        };
      };
    }];
  };
}
