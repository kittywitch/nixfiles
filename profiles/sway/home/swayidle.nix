{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.deploy.profile.sway {
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
            timeout 300 '${pkgs.swaylock}/bin/swaylock -f -i eDP-1:${
              ../../../private/files/wallpapers/main.png
            } -i HDMI-A-1:${
              ../../../private/files/wallpapers/main.png
            } -i DP-1:${
              ../../../private/files/wallpapers/left.jpg
            }  -i DVI-D-1:${../../../private/files/wallpapers/right.jpg}' \
            #timeout 600 'swaymsg "output * dpms off"' \
            #  resume 'swaymsg "output * dpms on"' \
            before-sleep '${pkgs.swaylock}/bin/swaylock -f -i eDP-1:${
              ../../../private/files/wallpapers/main.png
            } -i HDMI-A-1:${
              ../../../private/files/wallpapers/main.png
            } -i DP-1:${
              ../../../private/files/wallpapers/left.jpg
            }  -i DVI-D-1:${../../../private/files/wallpapers/right.jpg}'
        '';
        RestartSec = 3;
        Restart = "always";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };
  };
}
