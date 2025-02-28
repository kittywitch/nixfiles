{
  inputs,
  pkgs,
  config,
  ...
}: let
  konawallConfig = {
    interval = 30 * 60;
    rotate = true;
    api_key = "odD1Jo17zKWBYq8kMciskPWf";
    source = "e621";
    tags = [
      #"rating:s"
      #"touhou"
      "-male"
      "score:>=50"
      "width:>=1500"
    ];
    logging = {
      file = "INFO";
      console = "DEBUG";
    };
  };
in {
  home.packages = [
    inputs.konawall-py.packages.${pkgs.system}.konawall-py
  ];
  xdg.configFile = {
    "konawall/config.toml".source = (pkgs.formats.toml {}).generate "konawall-config" konawallConfig;
  };
  systemd.user.services.konawall-py-gnome = {
    Unit = {
      Description = "konawall-py";
      X-Restart-Triggers = [(toString config.xdg.configFile."konawall/config.toml".source)];
      After = ["graphical-session.target" "network-online.target"];
    };
    Service = {
      ExecStart = "${inputs.konawall-py.packages.${pkgs.system}.konawall-py}/bin/konawall";
      Restart = "on-failure";
      RestartSec = "1s";
    };
    Install = {WantedBy = ["graphical-session.target"];};
  };
}
