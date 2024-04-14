{
  inputs,
  pkgs,
  config,
  ...
}: let
  konawallConfig = {
    interval = 60 * 5;
    rotate = true;
    source = "konachan";
    tags = [
      "rating:s"
      "touhou"
      "score:>=50"
      "width:>=1500"
    ];
    logging = {
      file = "INFO";
      console = "DEBUG";
    };
  };
in {
  systemd.user.services.konawall-py = {
    Unit = {
      Description = "konawall-py";
      X-Restart-Triggers = [(toString config.xdg.configFile."konawall/config.toml".source)];
      After = ["gnome-session.target" "network-online.target"];
      Environment = [
        "PYSTRAY_BACKEND=gtk"
      ];
    };
    Service = {
      ExecStart = "${inputs.konawall-py.packages.${pkgs.system}.konawall-py}/bin/konawall";
      Restart = "on-failure";
      RestartSec = "1s";
    };
    Install = {WantedBy = ["graphical-session.target"];};
  };
  xdg.configFile = {
    "konawall/config.toml".source = (pkgs.formats.toml {}).generate "konawall-config" konawallConfig;
  };
}
