{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome.adwaita-icon-theme
  ];
  base16.gtk.enable = false;
  gtk = {
    enable = true;
    font = {
      name = "Iosevka Aile";
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
