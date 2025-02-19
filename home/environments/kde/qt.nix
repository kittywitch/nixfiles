{pkgs, ...}: {
  xdg.configFile."menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  qt = {
    enable = false;
    platformTheme.package = with pkgs.kdePackages; [
      plasma-integration
      # I don't remember why I put this is here, maybe it fixes the theme of the system setttings
      systemsettings
    ];
    style = {
      package = pkgs.kdePackages.breeze;
      name = "Breeze";
    };
  };
  systemd.user.sessionVariables = {QT_QPA_PLATFORMTHEME = "qt6ct";};
}
