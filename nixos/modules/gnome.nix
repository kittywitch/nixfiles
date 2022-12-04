{ config, lib, pkgs, ... }: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.role.gnome {
    services.xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };

    environment.systemPackages = with pkgs.gnomeExtensions; [
      dash-to-dock
      gsconnect
    ];
  };
}
