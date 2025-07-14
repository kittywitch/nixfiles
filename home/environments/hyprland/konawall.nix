{
  inputs,
  pkgs,
  config,
  ...
}: let
  konawallConfig = {
in {
  sops.secrets.konawall-py-env = {
    sopsFile = ./konawall.yaml;
  };
  programs.konawall-py = {
    enable = true;
    settings = {
      interval = 30 * 60;
      rotate = true;
      tags = [
        "score:>=100"
        "width:>=1500"
      ];
      logging = {
        file = "INFO";
        console = "DEBUG";
      };
    };
    environmentFile = sops.secrets.konawall-py-env.pathg;
  };
}
