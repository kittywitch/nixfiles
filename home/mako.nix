{ config, pkgs, lib, witch, ... }:

let
  inherit (config.kw.theme) base16;
in
{
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
    font = "${config.kw.theme.font.name} ${toString config.kw.theme.font.size}";
    defaultTimeout = 3000;
    borderColor = base16.base08;
    backgroundColor = "${base16.base00}BF";
    textColor = base16.base05;
  };
}
