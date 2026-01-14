{ lib, pkgs, ... }: {
  wayland.windowManager.hyprland.settings.exec-once = let
    inherit (lib.meta) getExe getExe';
  in [
    "${getExe pkgs.swww} init"
    "${getExe' pkgs.dbus "dbus-update-activation-environment"} --all"
    (getExe' pkgs.networkmanagerapplet "nm-applet")
    (getExe' pkgs.udiskie "udiskie")
    "${getExe' pkgs.systemd "systemctl"} restart konawall-py --user"
  ];
}
