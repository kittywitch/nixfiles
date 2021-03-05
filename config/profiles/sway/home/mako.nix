{ config, pkgs, lib, witch, ... }:

{
  config = lib.mkIf config.deploy.profile.sway {
    systemd.user.services = {
      mako = {
        Unit = {
          Description = "mako";
          X-Restart-Triggers =
            [ (toString config.xdg.configFile."mako/config".source) ];
        };
        Service = {
          ExecStart = "${pkgs.mako}/bin/mako";
          Restart = "always";
        };
        Install = { WantedBy = [ "graphical-session.target" ]; };
      };
    };

    programs.mako = {
      enable = true;
      defaultTimeout = 3000;
      borderColor = witch.style.base16.color7;
      backgroundColor = "${witch.style.base16.color0}70";
      textColor = witch.style.base16.color7;
    };
  };
}
