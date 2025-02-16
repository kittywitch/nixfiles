{pkgs, ...}: {
  gtk = {
    enable = false;
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
  };
}
