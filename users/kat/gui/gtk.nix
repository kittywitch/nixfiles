{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Numix-Square";
      package = pkgs.numix-icon-theme-square;
    };
    theme = {
      name = "Adementary Dark";
      package = pkgs.adementary-theme;
    };
  };
}
