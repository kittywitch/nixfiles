{pkgs, ...}: {
  stylix.targets.vesktop.enable = false;
  home.packages = [
    (pkgs.discord.override {
      withVencord = true;
    })
  ];
  programs.vesktop = {
    enable = false;
    settings = {
      autoUpdate = false;
      autoUpdateNotification = false;
      notifyAboutUpdates = false;
      disableMinSize = true;
      plugins = {
      };
    };
  };
}
