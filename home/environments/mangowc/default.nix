{
  lib,
  pkgs,
  ...
}: let
  rawVariables = [
            "DISPLAY"
            "WAYLAND_DISPLAY"
            "XDG_CURRENT_DESKTOP"
            "XDG_SESSION_TYPE"
            "NIXOS_OZONE_WL"
            "XCURSOR_THEME"
            "XCURSOR_SIZE"
  ];
  variables = lib.concatStringsSep " " rawVariables;
  rawExtraCommands = [
    "systemctl --user reset-failed"
    "systemctl --user start mango-session.target"
  ];
  extraCommands = lib.concatStringsSep " && " rawExtraCommands;
  systemdActivation = ''${pkgs.dbus}/bin/dbus-update-activation-environment --systemd ${variables}; ${extraCommands}'';
  autostart_sh = pkgs.writeShellScript "autostart.sh" ''
    ${systemdActivation}
  '';
in {
  config = {
    programs.waybar.enable = true;
    home.packages = [ pkgs.mangowc ];
    xdg.configFile = {
      "mango/config.conf".text = ''
      '';
      "mango/autostart.sh" = {
        source = autostart_sh;
        executable = true;
      };
    };
    systemd.user.targets.mango-session = {
      Unit = {
        Description = "mango compositor session";
        Documentation = ["man:systemd.special(7)"];
        BindsTo = ["graphical-session.target"];
        Wants =
          [
            "graphical-session-pre.target"
          ];
        After = ["graphical-session-pre.target"];
      };
    };
  };
}
