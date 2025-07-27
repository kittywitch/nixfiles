_: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: Monaspace Krypton, monospace;
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
        all:unset;
      }


      .modules-left, .modules-right, .modules-center {
        background: alpha(@base00, 0.9);
        box-shadow: 0px 0px 2px rgba(0,0,0,0.6);
        color: @text;
        padding: 5px;
        margin: 2px 4px;
        border: 1px solid @base04;
      }

      tooltip {
        background: rgba(43, 48, 59, 0.5);
        border: 1px solid rgba(100, 114, 125, 0.5);
      }
      tooltip label {
        color: white;
      }

      #workspaces {
        border-right: 1px solid @surface2;
      }


      #workspaces button.persistent {
        background: @theme_unfocused_bg_color;
        color: @subtext1;
      }

      #workspaces button {
          padding: 2px 5px;
          background: @surface0;
          border-bottom: 3px solid transparent;
      }

      #workspaces button.empty {
        background: @base01;
        color: @base05;
      }

      #workspaces button.visible {
          background: @base02;
          color: @base04;
          border-bottom: 3px solid @base0C;
      }

      #workspaces button.urgent {
        background: @base08;
        color: @theme_selected_fg_color;
      }

      #workspaces button.active, #workspaces button.focused {
          background: @theme_selected_bg_color;
          color: @theme_selected_fg_color;
          border-bottom: 3px solid @base0E;
      }

      #window {
        padding: 0 10px;
      }

      window#waybar.empty #window {
        padding: 0px;
        margin: 0px;
      }

      #mode, #clock, #battery, #idle_inhibitor, #tray, #wireplumber, #bluetooth, #backlight, #mpris {
          padding: 0 5px;
          margin: 0 5px;
      }

      #mpris {
        color: @mantle;
      }

      #mpris.playing {
        background-color: @base0E;
      }

      #mpris.paused {
        background-color: @base09;
      }

      #mpris.stopped {
        background-color: @base08;
      }

      #mode {
          background: @base07;
          border-bottom: 3px solid @base0E;
          color: @base06;
      }

      #clock {
      }

      #battery {
      }

      #battery.charging {
          color: white;
          background-color: #26A65B;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: black;
          }
      }

      #battery.warning:not(.charging) {
          background: #f53c3c;
          color: white;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }
    '';
    settings.main = {
      layer = "top";
      position = "top";
      mode = "dock";
      exclusive = true;
      modules-left = [
        "niri/workspaces"
        "niri/window"
      ];

      modules-center = [
        "clock"
        "mpris"
      ];

      modules-right = [
        "privacy"
        "bluetooth"
        "wireplumber"
        "idle_inhibitor"
        "power-profiles-daemon"
        "backlight"
        "battery"
        "tray"
      ];

      idle_inhibitor = {
        format = "idin {icon}";
        format-icons = {
          activated = "active";
          deactivated = "inactive";
        };
      };

      bluetooth = {
        on-click = "blueman-manager";
        format = "bt {status}";
        format-connected-battery = "bt {device_alias} {device_battery_percentage}%";
        format-connected = "bt {num_connections} connected";
        tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
        tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
      };
      mpris = {
        ignored-players = ["firefox"];
      };
      wireplumber = {
        format = "vol {volume}%";
        max-volume = 150;
      };
      backlight = {
        format = "bl {percent}%";
      };
      battery = {
        format = "bat {capacity}%";
        format-tooltip = "{power}W, {timeTo}, {health}%";
        interval = 60;

        states = {
          warning = 30;
          critical = 15;
        };
      };

      tray = {
        spacing = 4;
      };

      clock = {
        format = "{:%F %H:%M %Z}";
        interval = 60;
      };
    };
  };
}
