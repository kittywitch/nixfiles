{ pkgs, ... }: {
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
    base16Scheme = "${pkgs.base16-schemes}/share/themes/sakura.yaml";
  };
}
