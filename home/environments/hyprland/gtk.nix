{pkgs, ...}: {
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Numix-Square-Light";
      package = pkgs.numix-icon-theme-square;
    };

    theme = {
      name = "Arc";
      package = pkgs.arc-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    font = {
      name = "Monaspace Krypton";
      size = 11;
    };
  };
}
