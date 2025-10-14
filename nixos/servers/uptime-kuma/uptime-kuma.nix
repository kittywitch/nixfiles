{config, ...}: let
  domain = "kuma.kittywit.ch";
  cfg = config.services.uptime-kuma;
in {
  services.uptime-kuma = {
    enable = true;
    settings = {
    };
  };
  services.nginx.virtualHosts.${domain} = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://localhost:${toString cfg.settings.PORT}";
        proxyWebsockets = true;
      };
    };
  };
}
