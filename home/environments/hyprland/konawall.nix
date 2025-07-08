{
  inputs,
  pkgs,
  config,
  ...
}: let
  konawallConfig = {
    interval = 30 * 60;
    rotate = true;
    source = "e621";
    tags = [
      "-rating:s"
      "-male/male"
      "-five_nights_at_freddy's"
      #"touhou"
      "-male"
      "-large_breasts"
      "-scalie"
      #"-my_little_pony"
      "-sonic_the_hedgehog"
      "-amputee"
      "-inflation"
      "-pool_toy"
      "-cuckold"
      "-gore"
      "-human"
      "-animated"
      "-hyper"
      "-death"
      "ratio:>=1.3"
      "-muscular_male"
      "-model_sheet"
      "score:>=100"
      "width:>=1500"
    ];
    logging = {
      file = "INFO";
      console = "DEBUG";
    };
  };
in {
  sops.secrets.konawall-py-env = {
    sopsFile = ./konawall.yaml;
  };
  home.packages = [
    inputs.konawall-py.packages.${pkgs.system}.konawall-py
  ];
  xdg.configFile = {
    "konawall/config.toml".source = (pkgs.formats.toml {}).generate "konawall-config" konawallConfig;
  };
  systemd.user.services.konawall-py = {
    Unit = {
      Description = "konawall-py";
      X-Restart-Triggers = [(toString config.xdg.configFile."konawall/config.toml".source)];
      After = ["graphical-session.target" "network-online.target"];
    };
    Service = {
      ExecStart = "${inputs.konawall-py.packages.${pkgs.system}.konawall-py}/bin/konawall";
      Restart = "on-failure";
      RestartSec = "1s";
      EnvironmentFile = config.sops.secrets.konawall-py-env.path;
    };
    Install = {WantedBy = ["graphical-session.target"];};
  };
}
