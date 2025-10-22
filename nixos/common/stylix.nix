{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.adwaita-icon-theme
  ];
  stylix = {
    enable = true;
    targets = {
      grub.useWallpaper = false;
    };
    homeManagerIntegration = {
      followSystem = true;
      autoImport = false;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 32;
    };
    opacity = {
      desktop = 1.0;
      applications = 1.0;
      terminal = 0.8;
      popups = 0.8;
    };
    image = ./stylix.png;
    polarity = "dark";
    fonts = {
      sansSerif = {
        name = "CozetteCrossedSevenVector";
        package = pkgs.cozette;
      };
      serif = {
        name = "Libre Baskerville";
        package = pkgs.libre-baskerville;
      };
      monospace = {
        name = "CozetteCrossedSevenVector";
        package = pkgs.cozette;
      };
    };
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  };
}
