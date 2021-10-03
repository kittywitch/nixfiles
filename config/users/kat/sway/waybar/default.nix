{ config, lib, pkgs, kw, ... }: with lib;

{
  xdg.configFile."waybar/style.css" = { inherit (kw.sassTemplate { name = "waybar-style"; src = ./waybar.sass; }) source; };

  systemd.user.services.waybar.Service.Environment = singleton "NOTMUCH_CONFIG=${config.home.sessionVariables.NOTMUCH_CONFIG}";

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [{
      modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
      modules-center = [ "clock" "clock#s" "clock#arc" "clock#miku" "clock#hex" ];
      modules-right = [
        "pulseaudio"
        "custom/mail"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "backlight"
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
        };
        tray = {
          icon-size = 12;
          spacing = 2;
        };
        backlight = {
          format = "{icon} {percent}%";
          format-icons = ["" ""];
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
          on-click = "${pkgs.waybar-konawall}/bin/konawall-toggle";
          on-click-right = "systemctl --user restart konawall";
          signal = 8;
        };
        "custom/mail" = {
          format = " {}";
          interval = 30;
          exec = "${pkgs.notmuch-arc}/bin/notmuch count tag:flagged OR tag:inbox AND NOT tag:killed";
        };
        cpu = { format = " {usage}%"; };
        memory = { format = " {percentage}%"; };
        temperature = {
          format = "{icon} {temperatureC}°C";
          format-icons = ["" "" ""];
          critical-threshold = 80;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
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
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
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
          ];
          interval = 1;
        };
        "clock#s" = {
          format = "-{:%H}";
          tooltip = true;
          timezone = "America/Chicago";
          tooltip-format = "{:%A, %F %R %z (%Z)}";
        };
        "clock#arc" = {
          format = "-{:%H}";
          tooltip = true;
          timezone = "America/Vancouver";
          tooltip-format = "{:%A, %F %R %z (%Z)}";
        };
        "clock#miku" = {
          format = "+{:%H}";
          tooltip = true;
          timezone = "Pacific/Auckland";
          tooltip-format = "{:%A, %F %R %z (%Z)}";
        };
        "clock#hex" = {
          format = "+{:%H}";
          tooltip = true;
          timezone = "Europe/Berlin";
          tooltip-format = "{:%A, %F %R %z (%Z)}";
        };
      };
    }];
  };
}
