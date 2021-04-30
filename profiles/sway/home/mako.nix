{ config, pkgs, lib, witch, ... }:

let witch.style.base16 = lib.mapAttrs' (k: v: lib.nameValuePair k "#${v.hex.rgb}") config.lib.arc.base16.schemeForAlias.default; witch.style.font = {
    name = "FantasqueSansMono Nerd Font";
    size = "10";
    size_css = "14px";
  }; in {
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
    borderColor = witch.style.base16.base0A;
    backgroundColor = "${witch.style.base16.base00}70";
    textColor = witch.style.base16.base05;
  };
}
