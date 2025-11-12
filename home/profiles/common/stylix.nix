{pkgs, ...}: {
  home.packages = [
    pkgs.adwaita-icon-theme
  ];
  stylix = {
    enable = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
    };
    image = ./stylix.png;
    icons = {
      enable = true;
      light = "MoreWaita";
      dark = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    opacity = {
      desktop = 1.0;
      applications = 1.0;
      terminal = 0.9;
      popups = 0.8;
    };
    polarity = "dark";
    fonts = {
      sansSerif = {
        name = "Atkinson Hyperlegible Next";
        package = pkgs.atkinson-hyperlegible-next;
      };
      serif = {
        name = "Libre Baskerville";
        package = pkgs.libre-baskerville;
      };
      monospace = {
        name = "Atkinson Hyperlegible Mono";
        package = pkgs.atkinson-hyperlegible-mono;
      };
    };
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  };
}
