{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
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
