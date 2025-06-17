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
    background: @theme_base_color;
    border-bottom: 1px solid @unfocused_borders;
    color: @theme_text_color;
}

tooltip {
  background: rgba(43, 48, 59, 0.5);
  border: 1px solid rgba(100, 114, 125, 0.5);
}
tooltip label {
  color: white;
}

#workspaces button.persistent {
  background: shade(@insensitive_bg_color, 0.5);
  color: shade(@insensitive_fg_color, 0.5);
}

#workspaces button {
    padding: 0 5px;
    background: @theme_unfocused_bg_color;
    border-bottom: 3px solid transparent;
}

#workspaces button.active, #workspaces button.focused {
    background: @theme_selected_bg_color;
    color: @theme_selected_fg_color;
    border-bottom: 3px solid white;
}

#mode, #clock, #battery, #idle_inhibitor, #tray, #window, #wireplumber, #bluetooth, #mpris {
    padding: 0 5px;
    margin: 0 5px;
}

#mode {
    background: #64727D;
    border-bottom: 3px solid white;
}

#clock, #mpris {
    background-color: #64727D;
}

#battery {
    background-color: #ffffff;
    color: black;
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
  height = 24;
      modules-left = [
        "hyprland/workspaces"
        "hyprland/submap"
        "hyprland/window"
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
        "battery"
        "tray"
      ];

      bluetooth = {
        on-click = "blueman-manager";
      };
      clock = {
        format = "{:%F %H:%M %Z}";
      };
    };
  };
}
