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
          timeout 300 '${pkgs.swaylock}/bin/swaylock -f  -i eDP-1:${../../../../users/kat/sway/wallpapers/main.png} \
          timeout 600 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
          before-sleep '${pkgs.swaylock}/bin/swaylock -f -i eDP-1:${../../../../users/kat/sway/wallpapers/main.png}'
      '';
      RestartSec = 3;
      Restart = "always";
    };
    Install = { WantedBy = [ "sway-session.target" ]; };
  };
}
