{config, ...}: {
  stylix.targets.avizo.enable = config.services.avizo.enable;
  services.avizo = {
    enable = false;
    settings = {
      default = {
        block-count = 100;
        block-spacing = 0;
        border-radius = 8;
        border-width = 2;
      };
    };
  };
}
