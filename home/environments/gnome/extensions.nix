{pkgs, ...}: {
  dconf = {
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "trayIconsReloaded@selfmade.pl"
          "Vitals@CoreCoding.com"
          "dash-to-panel@jderose9.github.com"
          "space-bar@luchrioh"
          "date-menu-formatter@marcinjakubowski.github.com"
        ];
      };
      "org/gnome/shell/extensions/date-menu-formatter" = {
        pattern = "y-MM-dd kk:mm XXX";
        "font-size" = "12";
      };
      "org/gnome/shell/extensions/vitals" = {
        "hot-sensors" = ["_memory_usage_" "_system_load_1m_" "__network-rx_max__" "_temperature_k10temp_tctl_"];
      };
    };
  };

  home.packages = with pkgs.gnomeExtensions; [
    space-bar
    user-themes
    tray-icons-reloaded
    vitals
    dash-to-panel
    date-menu-formatter
  ];
}
