{
  pkgs,
  ...
}: {
  programs.niri.settings.spawn-at-startup = let
    import-gsettings = pkgs.writeShellScriptBin "import-gsettings" ''
      # usage: import-gsettings
      config="''${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
      if [ ! -f "$config" ]; then exit 1; fi

      gnome_schema="org.gnome.desktop.interface"
      gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
      ${pkgs.glib}/bin/gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
      ${pkgs.glib}/bin/gsettings set "$gnome_schema" icon-theme "$icon_theme"
      ${pkgs.glib}/bin/gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
      ${pkgs.glib}/bin/gsettings set "$gnome_schema" font-name "$font_name"
    '';
  in [
    {
      command = [
        "${import-gsettings}/bin/import-gsettings"
      ];
    }
    {
      command = [
        "${pkgs.systemd}/bin/systemctl"
        "--user"
        "start"
        "waybar.service"
      ];
    }
    {
      command = [
        "${pkgs.systemd}/bin/systemctl"
        "--user"
        "restart"
        "konawall-py.service"
      ];
    }
    {
      command = [
        "${pkgs.systemd}/bin/systemctl"
        "--user"
        "start"
        "mako.service"
      ];
    }
    #{
    #  command = [
    #    "${pkgs.xwayland-satellite}/bin/xwayland-satellite"
    #  ];
    #}
    # program autostart
    {
      command = [
        "firefox"
      ];
    }
    {
      command = [
        "discord"
      ];
    }
  ];
}
