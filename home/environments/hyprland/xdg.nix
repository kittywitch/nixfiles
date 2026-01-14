{ lib, pkgs, ... }: let
  inherit (lib.generators) toINI;
in {
  xdg = {
    enable = true;
    autostart.enable = true;
    mime.enable = true;
    portal = {
      xdgOpenUsePortal = true;
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
      ];
    };

    mimeApps = {
      enable = true;
    };
  };
  xdg.configFile."xdg-desktop-portal/hyprland-portals.conf".text = toINI {} {
        preferred = {
          default = "hyprland;gtk";
          "org.freedesktop.impl.portal.FileChooser" = "kde";
          "org.freedesktop.impl.portal.AppChooser" = "kde";
        };
  };
}
