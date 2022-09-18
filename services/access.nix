{ config, lib, meta, pkgs, ... }: with lib; {
  domains = {
    kittywitch-plex = {
      network = "internet";
      type = "cname";
      domain = "plex";
    };
    kittywitch-home = {
      network = "internet";
      type = "cname";
      domain = "home";
    };
    kittywitch-cloud = {
      network = "internet";
      type = "cname";
      domain = "cloud";
    };
    gensokyo-root = {
      network = "internet";
      type = "both";
      zone = "gensokyo.zone.";
    };
    gensokyo-home = {
      network = "internet";
      type = "cname";
      domain = "home";
      zone = "gensokyo.zone.";
    };
    gensokyo-z2m = {
      network = "internet";
      type = "cname";
      domain = "z2m";
      zone = "gensokyo.zone.";
    };
  };

  services.nginx.virtualHosts = mkMerge [
    {
      "gensokyo.zone" = {
        locations."/" = {
          root = pkgs.gensokyoZone;
        };
      };
      "home.gensokyo.zone" = {
        locations = {
          "/" = {
            proxyPass = meta.tailnet.tewi.pp 4 8123;
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
                proxy_http_version 1.1;
            '';
          };
        };
      };
      "home.${config.networking.domain}" = {
        locations = {
          "/" = {
            proxyPass = meta.tailnet.yukari.pp 4 8123;
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              proxy_http_version 1.1;
            '';
          };
        };
      };
      "cloud.${config.networking.domain}" = {
        locations = {
          "/".proxyPass = meta.tailnet.yukari.ppp 4 80 "nextcloud/";
        };
      };
      "plex.${config.networking.domain}" = {
        locations = {
          "/" = {
            proxyPass = meta.tailnet.yukari.pp 4 32400;
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              proxy_redirect off;
              proxy_buffering off;
              proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
              proxy_set_header X-Plex-Device $http_x_plex_device;
              proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
              proxy_set_header X-Plex-Platform $http_x_plex_platform;
              proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
              proxy_set_header X-Plex-Product $http_x_plex_product;
              proxy_set_header X-Plex-Token $http_x_plex_token;
              proxy_set_header X-Plex-Version $http_x_plex_version;
              proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
              proxy_set_header X-Plex-Provides $http_x_plex_provides;
              proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
              proxy_set_header X-Plex-Model $http_x_plex_model;
            '';
          };
          };
        };
      }
  ];
}
