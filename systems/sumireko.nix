_: let
  hostConfig = {tree, pkgs, ...}: {
    imports = with tree; [
      kat.work
      darwin.distributed
    ];

    security.pam.enableSudoTouchIdAuth = true;

    homebrew = {
      brewPrefix = "/opt/homebrew/bin";
      brews = [
        "gnupg"
        "pinentry-mac"
      ];
      casks = [
        "utm"
        "discord"
        "mullvadvpn"
        "bitwarden"
        "deluge"
        "telegram-desktop"
        "spotify"
        "element"
        "signal"
        "brave-browser"
        "disk-inventory-x"
        "dozer"
        "devtoys"
        "cyberduck"
        "docker"
        "pycharm-ce"
        "vscode"
        "slack"
        "boop"
        "obsidian"
        "contexts"
        "rectangle"
      ];
      taps = [
        "pulumi/tap"
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
