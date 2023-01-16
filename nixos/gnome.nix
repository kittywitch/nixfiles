{
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  environment.systemPackages = with pkgs.gnomeExtensions; [
    dash-to-dock
    gsconnect
    appindicator
  ];

  services.udev.packages = with pkgs.gnome; [
    gnome-settings-daemon
  ];
}
