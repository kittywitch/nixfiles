{
  pkgs,
  ...
}: {
  home-manager.users.kat.wayland.windowManager.hyprland.settings.exec-once = [
    "${pkgs.colord}/bin/colormgr import-profile ${./framework-icc.icm}"
  ];
}
