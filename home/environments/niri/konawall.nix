{config, ...}: {
  sops.secrets.konawall-py-env = {
    sopsFile = ./konawall.yaml;
  };
  programs.konawall-py = {
    enable = true;
    settings = {
      interval = 30 * 60;
      rotate = true;
      tags = [
        "rating:s"
        "score:>=100"
        "width:>=1500"
      ];
      logging = {
        file = "INFO";
        console = "DEBUG";
      };
    };
    environmentFile = config.sops.secrets.konawall-py-env.path;
  };
}
