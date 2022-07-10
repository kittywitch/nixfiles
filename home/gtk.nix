{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = false;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Adapta";
      package = pkgs.adapta-gtk-theme;
    };
  };
}
