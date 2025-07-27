{config, ...}: {
  home.pointerCursor = {
    dotIcons.enable = true;
    x11 = {
      enable = true;
      defaultCursor = config.home.pointerCursor.name;
    };
    gtk.enable = true;
  };
}
