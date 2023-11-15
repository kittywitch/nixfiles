_: let
  hostConfig = {
    tree,
    pkgs,
    ...
  }: {
    imports = with tree.darwin; [
      orbstack
    ];

    home-manager.users.kat.imports =
      (with tree.home.profiles; [
        graphical.gpg
        graphical.vscode
        graphical.wezterm
      ])
      ++ (with tree.home.profiles; [
        devops
      ])
      ++ (with tree.home.environments; [
        darwin
      ]);

    security.pam.enableSudoTouchIdAuth = true;

    environment.systemPackages = with pkgs; [
    ];

    home-manager.users.kat = {
      home.sessionVariables = {
        ARTEMISCLI_CONFIG_PATH = "/Users/kat/.artemisconfig";
      };
      programs = {
        zsh = {
          initExtra = ''
            source <(kubectl completion zsh)
          '';
        };
      };
    };

    homebrew = {
      brewPrefix = "/opt/homebrew/bin";
      brews = [
        "gnupg"
        "pinentry-mac"
        "awscurl"
        "pandoc"
        "openjdk@17"
        "maven"
        "dependency-check"
        "snyk"
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
        "pulumi/tap"
        "homebrew/cask-versions"
        "snyk/tap"
      ];
      masApps = {
        Tailscale = 1475387142;
        Dato = 1470584107;
        Lungo = 1263070803;
        "Battery Indicator" = 1206020918;
      };
    };

    system.stateVersion = 4;
  };
in {
  arch = "aarch64";
  type = "macOS";
  modules = [
    hostConfig
  ];
}
