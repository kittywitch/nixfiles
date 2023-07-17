{
  config,
  pkgs,
  ...
}: let
  inherit (config.base16) palette;
in {
  systemd.user.services = {
    mako = {
      Unit = {
        Description = "mako";
        X-Restart-Triggers = [(toString config.xdg.configFile."mako/config".source)];
      };
      Service = {
        ExecStart = "${pkgs.mako}/bin/mako";
        Restart = "always";
      };
      Install = {WantedBy = ["graphical-session.target"];};
    };
  };

  services.mako = {
    enable = true;
    font = "Iosevka 10";
    defaultTimeout = 3000;
    borderColor = palette.base08;
    backgroundColor = "${palette.base00}BF";
    textColor = palette.base05;
  };
}
