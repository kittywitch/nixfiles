{ config, lib, pkgs, tf, ... }:

with lib;

{
  secrets.files.dns_creds = {
    text = ''
      RFC2136_NAMESERVER='${tf.variables.katdns-address.ref}'
      RFC2136_TSIG_ALGORITHM='hmac-sha512.'
      RFC2136_TSIG_KEY='${tf.variables.katdns-name.ref}'
      RFC2136_TSIG_SECRET='${tf.variables.katdns-key.ref}'
    '';
  };

  network.firewall = {
    public.tcp.ports = [ 443 80 ];
    private.tcp.ports = [ 443 80 ];
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    commonHttpConfig = ''
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;
      #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
      add_header 'Referrer-Policy' 'origin-when-cross-origin';
      #add_header X-Frame-Options DENY;
      #add_header X-Content-Type-Options nosniff;
      #add_header X-XSS-Protection "1; mode=block";
      #proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
    clientMaxBodySize = "512m";
  virtualHosts = {
      "gensokyo.zone" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = pkgs.gensokyoZone;
        };
      };
      "home.${config.network.dns.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8123";
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
                proxy_http_version 1.1;
            '';
          };
        };
      };
    };
  };

  security.acme = {
    defaults.email = config.network.dns.email;
    #email = config.network.dns.email;
    acceptTerms = true;
  };
}
