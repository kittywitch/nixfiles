_: {
  stylix.targets.vesktop.enable = false;
  programs.vesktop = {
    enable = true;
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
