_: {
  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        favorite-apps = [
          "brave-browser.desktop"
          "thunderbird.desktop"
          "nheko.desktop"
          "discord.desktop"
          "signal-desktop.desktop"
          "org.telegram.desktop.desktop"
          "codium.desktop"
          "obsidian.desktop"
          "org.wezfurlong.wezterm.desktop"
          "spotify.desktop"
          "steam.desktop"
          "org.gnome.Nautilus.desktop"
          "bitwarden.desktop"
        ];
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
      };
      "org/gnome/desktop/wm/preferences" = {
        workspace-names = ["Main"];
      };
    };
  };
}
