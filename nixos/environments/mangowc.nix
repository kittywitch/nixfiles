{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.mangowc ];
  services.displayManager.sessionPackages = [ pkgs.mangowc ];
  services.graphical-desktop.enable = true;
  xdg.portal = {
    enable = true;
    config.mango = {
    default = [
        "gtk"
      ];
      "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
      "org.freedesktop.impl.portal.FileChooser" = ["kde"];
      "org.freedesktop.impl.portal.AppChooser" = ["kde"];
      "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
      "org.freedesktop.impl.portal.ScreenShot" = ["wlr"];
      "org.freedesktop.impl.portal.Inhibit" = [];
    };
    wlr.enable = true;
    configPackages = [ pkgs.mangowc ];
    extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
    ];
  };
  programs.xwayland.enable = true;
  security.polkit.enable = true;
}
