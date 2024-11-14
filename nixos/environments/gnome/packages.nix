{pkgs, ...}: {
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    cheese # webcam tool
    epiphany # web browser
    geary # email reader
    gnome-characters
    gnome-contacts
    gnome-initial-setup
  ];
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
  ];
  services.udev.packages = [pkgs.gnome.gnome-settings-daemon];
}
