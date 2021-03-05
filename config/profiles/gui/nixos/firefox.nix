{ config, pkgs, lib, witch, ... }:

{
  config = lib.mkIf config.deploy.profile.gui {
    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        gtkUsePortal = true;
      };
    };
  };
}
