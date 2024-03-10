{pkgs, ...}: {
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      gnome-characters
      gnome-contacts
      gnome-initial-setup
    ]);
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome-extension-manager
  ];
}
