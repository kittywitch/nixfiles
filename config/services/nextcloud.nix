{ config, pkgs, lib, tf, kw, ... }: with lib; let
  cfg = config.services.nextcloud;
in {
  deploy.tf.dns.records.services_internal_cloud = {
    inherit (config.network.dns) zone;
    domain = "cloud.int";
    cname = { inherit (config.network.addresses.yggdrasil) target; };
  };

  kw.secrets.variables =
    mapListToAttrs
      (field:
        nameValuePair "nextcloud-${field}" {
          path = "secrets/nextcloud";
          inherit field;
        }) [ "adminpass" "dbpass" ];

  secrets.files.nextcloud-adminpass = {
    text = ''
      ${tf.variables.nextcloud-adminpass.ref}
    '';
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [{
      name = "nextcloud";
      ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
    }];
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud23;
    config = {
      dbtype = "pgsql";
      dbhost = "/run/postgresql";
      defaultPhoneRegion = "GB";
      adminpassFile = config.secrets.files.nextcloud-adminpass.path;
      extraTrustedDomains = [
        "cloud.kittywit.ch"
      ];
    };
    https = true;
    enableImagemagick = true;
    home = "/mnt/zraw/nextcloud";
    hostName = "cloud.kittywit.ch";
    autoUpdateApps = {
      enable = true;
    };
  };

  services.nginx.virtualHosts."cloud.kittywit.ch".extraConfig = mkForce ''
          index index.php index.html /index.php$request_uri;
          add_header X-Content-Type-Options nosniff;
          add_header X-XSS-Protection "1; mode=block";
          add_header X-Robots-Tag none;
          add_header X-Download-Options noopen;
          add_header X-Permitted-Cross-Domain-Policies none;
          add_header X-Frame-Options sameorigin;
          add_header Referrer-Policy no-referrer;
          client_max_body_size ${cfg.maxUploadSize};
          fastcgi_buffers 64 4K;
          fastcgi_hide_header X-Powered-By;
          gzip on;
          gzip_vary on;
          gzip_comp_level 4;
          gzip_min_length 256;
          gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
          gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
          ${optionalString cfg.webfinger ''
            rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
            rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;
          ''}
        '';
}
