{config, ...}: let
  cfg = config.services.ntfy-sh;
  domain = "ntfy.kittywit.ch";
in {
  sops.secrets.ntfy-env = {
    format = "yaml";
    sopsFile = ./ntfy.yaml;
  };
  services.ntfy-sh = {
    enable = true;
    environmentFile = config.sops.secrets.ntfy-env.path;
    settings = {
      base-url = "https://${domain}";
      auth-default-access = "deny-all";
    };
  };
  services.nginx.virtualHosts.${domain} = {
    enableACME = true;
    forceSSL = true;
    extraConfig = ''
      client_max_body_size 512M;
    '';
    locations = {
      "/" = {
        proxyPass = "http://${cfg.settings.listen-http}";
        proxyWebsockets = true;
      };
    };
  };
}
