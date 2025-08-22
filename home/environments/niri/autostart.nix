{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.meta) getExe getExe';
in {
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
    systemctl = getExe' pkgs.systemd "systemctl";
    packageExe' = pkgAttr: getExe' pkgs.${pkgAttr} pkgAttr;
    packageExe = pkgAttr: getExe pkgs.${pkgAttr};
    packageCommand = attr: {
      command = [
        (packageExe attr)
      ];
    };
    packageCommand' = attr: {
      command = [
        (packageExe' attr)
      ];
    };
    packages' = [
      "udiskie"
      "easyeffects"
      "pasystray"
    ];
    packages = [
      "pasystray"
      "pavucontrol"
      "networkmanagerapplet"
    ];
    packageCommands = let
      packageCommands' = map packageCommand' packages';
      packageCommands'' = map packageCommand packages;
    in
      packageCommands' ++ packageCommands'';
  in
    packageCommands
    ++ [
      {
        command = [
          "${getExe import-gsettings}"
        ];
      }
      {
        command = [
          "${systemctl}"
          "--user"
          "restart"
          "waybar.service"
        ];
      }
      {
        command = [
          "${systemctl}"
          "--user"
          "restart"
          "konawall-py.service"
        ];
      }
      {
        command = [
          "${systemctl}"
          "--user"
          "restart"
          "swaync.service"
        ];
      }
      {
        command = [
          "${getExe' config.programs.niriswitcher.package "niriswitcher"}"
        ];
      }
      {
        command = [
          "${getExe' pkgs.dbus "dbus-update-activation-environment"}"
          "--all"
        ];
      }
      {
        command = [
          "discord"
          "--enable-features=WaylandLinuxDrmSyncobj,UseOzonePlatform"
          "--ozone-platform=wayland"
        ];
      }
      {
        command = [
          "thunderbird"
        ];
      }
      {
        command = [
          "obsidian"
        ];
      }
      {
        command = [
          "zen-beta"
        ];
      }
    ];
}
