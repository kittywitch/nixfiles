{ kittywitch, pkgs, ... }:

{
  xdg.configFile."waybar/style.css" = { inherit (kittywitch.sassTemplate { name = "waybar-style"; src = ./waybar.sass; }) source; };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [{
      height = 10;
      modules-left = [
        "sway/workspaces"
          "sway/mode"
          "sway/window"
      ];
      modules-center = [
      ];
      modules-right = [
        "pulseaudio#icon"
          "pulseaudio"
          "cpu"
          "custom/memory-icon"
          "memory"
          "temperature#icon"
          "temperature"
          "battery#icon"
          "battery"
          "backlight#icon"
          "backlight"
          "network#icon"
          "network"
          "idle_inhibitor"
          "custom/clock"
          "tray"
          ];

        "sway/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1:";
            "2" = "2:";
            "3" = "3:";
          };
        };
        "sway/window" = {
          icon = true;
          icon-size = 12;
          format = "{}";
        };
        tray = {
          icon-size = 12;
          spacing = 2;
        };
        "backlight#icon" = {
          format = "{icon}";
          format-icons = ["" ""];
        };
        backlight = {
          format = "{percent}%";
        };
        "custom/cpu-icon".format = "";
        cpu.format = "{usage}%";
        "custom/memory-icon".format = "";
        memory.format = "{percentage}%";
        "temperature#icon" = {
          format = "{icon}";
          format-icons = ["" "" ""];
          critical-threshold = 80;
        };
        temperature = {
          format = "{temperatureC}°C";
          critical-threshold = 80;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        "battery#icon" = {
          states = {
            good = 90;
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "";
          format-plugged = "";
          format-icons = [ "" "" "" "" "" ];
        };
        battery = {
          states = {
            good = 90;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}%";
          format-charging = "{capacity}%";
          format-plugged = "{capacity}%";
          format-alt = "{time}";
        };
        "pulseaudio#icon" = {
          format = "{icon}";
          format-muted = "婢";
          on-click = "wezterm start pulsemixer";
          format-icons = {
            default = [
              ""
                ""
                ""
            ];
          };
        };
        pulseaudio = {
          format = "{volume}%";
          on-click = "${pkgs.wezterm}/bin/wezterm start ${pkgs.pulsemixer}/bin/pulsemixer";
        };
        "network#icon" = {
          format-wifi = "直";
          format-ethernet = "";
          format-linked = " ";
          format-disconnected = "";
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "{ipaddr}/{cidr}";
          format-linked = "No IP";
          format-disconnected = "Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        "custom/clock" = {
          exec = ''${pkgs.coreutils}/bin/date +"%a, %F %T %Z"'';
          interval = 1;
        };
    }];
  };
}
