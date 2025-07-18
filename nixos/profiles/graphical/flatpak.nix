_: {
  home-manager.sharedModules = [
    ({ config, ... }: {
      xdg.systemDirs.data = [
        "/var/lib/flatpak/exports/share"
        "/home/${config.home.username}/.local/share/flatpak/exports/share/"
      ];
    })
  ];
  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
    remotes = [
      { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
    ];
  };
}
