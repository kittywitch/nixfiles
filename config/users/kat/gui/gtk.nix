{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Adementary-dark";
      package = pkgs.adementary-theme;
    };
  };
}
