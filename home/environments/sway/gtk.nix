{pkgs, ...}: {
  home.packages = with pkgs; [
    gnome.adwaita-icon-theme
  ];

  gtk = {
    enable = true;
    font = {
      name = "Iosevka";
      size = 9;
    };
    iconTheme = {
      name = "Maia";
      package = pkgs.maia-icon-theme;
    };
    theme = {
      name = "Adapta";
      package = pkgs.adapta-gtk-theme;
    };
  };
}
