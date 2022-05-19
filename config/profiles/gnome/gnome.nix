{ config, pkgs, lib, ... }: {
  services = {
    xserver = {
      enable = true;
      desktopManager.gnome = {
        enable = true;
      };
      displayManager.gdm = {
        enable = true;
      };
    };
    mullvad-vpn.enable = true;
  };

  hardware.pulseaudio.enable = lib.mkForce false;
  xdg.portal.enable = lib.mkForce false;

  environment.systemPackages = (with pkgs.gnomeExtensions; [
    gsconnect
    vitals
    switcher
    espresso
    impatience
    noannoyance
    arcmenu
    tweaks-in-system-menu
    activities-icons
    random-wallpaper
    mullvad-indicator
    tray-icons-reloaded
    noannoyance-2
    dash-to-panel
  ]) ++ (with pkgs; [
    mullvad-vpn
    ytmdesktop
    pkgs.gnome.gnome-shell-extensions
    pkgs.gnome.gnome-tweaks
  ]);
}
