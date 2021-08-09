{ config, pkgs, lib, witch, ... }:

let
  base16 = lib.mapAttrs' (k: v: lib.nameValuePair k "#${v.hex.rgb}")
    config.lib.arc.base16.schemeForAlias.default;
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
    font = "${config.kw.font.name} ${toString config.kw.font.size}";
    defaultTimeout = 3000;
    borderColor = base16.base08;
    backgroundColor = lib.hextorgba base16.base00 0.75;
    textColor = base16.base05;
  };
}
