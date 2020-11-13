{ config, lib, pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  home-manager.users.kat = {
    home.packages = [
      pkgs.dconf2nix
      pkgs.gnome3.gnome-tweak-tool
      pkgs.gnomeExtensions.caffeine
      pkgs.gnomeExtensions.emoji-selector
      pkgs.gnomeExtensions.dash-to-panel
      pkgs.gnomeExtensions.appindicator
      pkgs.gnomeExtensions.dash-to-dock
      pkgs.gnomeExtensions.arc-menu
    ];
  };

  services.gvfs = {
    enable = true;
    package = pkgs.gnome3.gvfs;
  };
}
