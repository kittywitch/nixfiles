{ config, lib, pkgs, ... }:

{
	home.packages = with pkgs; [ lxappearance ];
	base16.gtk.enable = true;
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
