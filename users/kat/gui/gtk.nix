{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Numix-Square";
      package = pkgs.numix-icon-theme-square;
    };
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
  };
}
