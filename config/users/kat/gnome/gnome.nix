{ config, lib, pkgs, ... }: {
  home.packages = [ pkgs.pinentry-gnome pkgs.adapta-gtk-theme pkgs.papirus-icon-theme ];
  services.gpg-agent = {
    pinentryFlavor = lib.mkForce "gnome3";
  };
}
