{pkgs, ...}: {
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.chicago95;
    name = "Chicago95";
    size = 16;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Chicago95-tux";
      package = pkgs.chicago95;
    };

    theme = {
      name = "Chicago95";
      package = pkgs.chicago95;
    };

    cursorTheme = {
      name = "Chicago95";
      package = pkgs.chicago95;
    };

    font = {
      name = "Monaspace Krypton";
      size = 11;
    };
  };
}
