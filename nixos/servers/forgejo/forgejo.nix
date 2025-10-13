{config, ...}: let
  domain = "git.kittywit.ch";
  cfg = config.services.forgejo;
in {
  services.forgejo = {
    enable = true;
    settings = {
      DEFAULT = {
        APP_NAME = "kittywitch forge";
      };
      server = {
        DOMAIN = domain;
        ROOT_URL = "https://${domain}";
      };
      service = {
        DISABLE_REGISTRATION = true;
      };
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
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
        proxyPass = "http://localhost:${toString cfg.settings.server.HTTP_PORT}";
        proxyWebsockets = true;
      };
    };
  };
}
