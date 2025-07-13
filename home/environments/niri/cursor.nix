{config, ...}: {
  catppuccin.cursors.enable = true;
  home.pointerCursor = {
    dotIcons.enable = true;
    x11 = {
      enable = true;
      defaultCursor = config.home.pointerCursor.name;
    };
    gtk.enable = true;
    size = 32;
  };
}
