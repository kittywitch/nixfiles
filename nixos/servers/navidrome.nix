{config, ...}: let
  cfg = config.services.navidrome;
  domain = "music.kittywit.ch";
in {
  services = {
    navidrome = {
      enable = true;
      openFirewall = true;
    };
    nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations = {
        "/" = {
          proxyPass = "http://${cfg.settings.Address}:${toString cfg.settings.Port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
