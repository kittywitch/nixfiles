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
    fonts = {
      sansSerif = {
        name = "Jost";
        package = pkgs.jost;
      };
      serif = {
        name = "Libre Baskerville";
        package = pkgs.libre-baskerville;
      };
      monospace = {
        name = "Monaspace Krypton";
        package = pkgs.monaspace;
      };
    };
    autoEnable = true;
    polarity = "light";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";
  };
}
