{ config, pkgs, lib, ... }:

{
  systemd.user.services.swayidle = {
    Unit = {
      Description = "swayidle";
      Documentation = [ "man:swayidle(1)" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle -w \
          timeout 300 '${pkgs.swaylock}/bin/swaylock -f -i VGA-1:${builtins.elemAt config.kw.wallpapers 0} \
          timeout 600 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
          before-sleep '${pkgs.swaylock}/bin/swaylock -f -i VGA-1:${builtins.elemAt config.kw.wallpapers 0}'
      '';
      RestartSec = 3;
      Restart = "always";
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
  };
}
