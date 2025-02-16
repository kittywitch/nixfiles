{pkgs, ...}: {
  dconf = {
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "Vitals@CoreCoding.com"
          "dash-to-panel@jderose9.github.com"
          "space-bar@luchrioh"
          "appindicatorsupport@rgcjonas.gmail.com"
          "arcmenu@arcmenu.com"
          "date-menu-formatter@marcinjakubowski.github.com"
        ];
      };
      "org/gnome/shell/extensions/daerte-menu-formatter" = {
        pattern = "y-MM-dd HH:mm:ss ";
        "font-size" = "12";
      };
      "org/gnome/shell/extensions/vitals" = {
        "hot-sensors" = ["_memory_usage_" "_system_load_1m_" "__network-rx_max__" "_temperature_k10temp_tctl_"];
      };
    };
  };

  home.packages = with pkgs.gnomeExtensions; [
    pkgs.arcmenu
    space-bar
    user-themes
    tray-icons-reloaded
    appindicator
    caffeine
    vitals
    dash-to-panel
    date-menu-formatter
  ];
}
