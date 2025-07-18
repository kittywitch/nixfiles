{ pkgs, ... }: {
  xdg = {
    enable = true;
    autostart.enable = true;
    mime.enable = true;
    portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      gnome-keyring
    ];

    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "pcmanfm.desktop";
      };
    };
  };
}
