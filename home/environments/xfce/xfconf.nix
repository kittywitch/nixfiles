_: {
  xfconf = {
    settings = {
      xsettings = {
        "Xfce4/SyncThemes" = true;
        "Net/IconThemeName" = "Chicago95-tux";
        "Net/ThemeName" = "Chicago95";
      };
      xfce4-keyboard-shortcuts = {
        "commands/custom/Super_L" = "xfce4-popup-whiskermenu";
      };
      xfce4-session = {
        "startup/ssh-agent/enabled" = false;
      };
      xfce4-power-manager = {
        "xfce4-power-manager/show-tray-icon" = false;
        "xfce4-power-manager/general-notification" = true;
      };
      xfwm4 = {
        "general/theme" = "Chicago95";
        "general/title_font" = "Sans Bold 8";
        "general/show_dock_shadow" = false;
      };
      xfce4-notifyd = {
        "theme" = "Chicago95";
        "notify-location" = "bottom-right";
      };

    };
    enable = true;
  };
}
