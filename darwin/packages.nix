_: {
  homebrew = {
    brewPrefix = "/opt/homebrew/bin";
    brews = [
      # Security
      "gnupg" # GPG
      "pinentry-mac" # Pinentry for GPG

      # Utilities
      "pandoc"
    ];
    casks = [
      # Browsers
      "firefox"
      "google-chrome"

      # Chat
      "signal"
      "telegram"
      "discord"
      "element"
      "slack"
      "keybase"

      # Media
      "spotify"
      "deluge"

      # Exocortex
      "obsidian"

      # Security
      "bitwarden"
      "mullvadvpn"
      "pycharm-ce"

      # Development Tools
      "iterm2"
      "cyberduck"
      "boop"

      # Utilities
      "disk-inventory-x"
      "devtoys"
      "contexts"
      "rectangle"
      "syncthing"
      "anki"
      "bartender"
    ];

    taps = [
      "homebrew/cask-versions"
    ];
    masApps = {
      # Security

      Tailscale = 1475387142;
      # Utilities
      Dato = 1470584107;
      Lungo = 1263070803;
      "Battery Indicator" = 1206020918;
    };
  };
}
