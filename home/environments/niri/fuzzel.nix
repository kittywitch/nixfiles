{config, ...}: {
  stylix.targets.fuzzel.enable = config.programs.fuzzel.enable;
  programs.fuzzel = {
    enable = false;
  };
}
