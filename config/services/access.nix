{ config, lib, meta, pkgs, ... }: with lib; {
  deploy.tf.dns.records.services_plex = {
    inherit (config.network.dns) zone;
    domain = "plex";
    cname = { inherit (config.network.addresses.public) target; };
  };


  deploy.tf.dns.records.services_cloud = {
    inherit (config.network.dns) zone;
    domain = "cloud";
    cname = { inherit (config.network.addresses.public) target; };
  };
  
  deploy.tf.dns.records.services_home = {
    inherit (config.network.dns) zone;
    domain = "home";
    cname = { inherit (config.network.addresses.public) target; };
  };

  deploy.tf.dns.records.gensokyo_root_v4 = {
    zone = "gensokyo.zone.";
    a = { inherit (config.network.addresses.public.tf.ipv4) address; };
  };

  deploy.tf.dns.records.gensokyo_root_v6 = {
    zone = "gensokyo.zone.";
    aaaa = { inherit (config.network.addresses.public.tf.ipv6) address; };
  };

  services.nginx.virtualHosts = mkMerge [
    {
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
            proxyPass = "http://yukari.ygg.kittywit.ch:8123";
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
                proxy_http_version 1.1;
            '';
          };
        };
      };
      "cloud.${config.network.dns.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/".proxyPass = "http://cloud.int.kittywit.ch/";
        };
      };
      "plex.${config.network.dns.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://[${meta.network.nodes.nixos.yukari.network.addresses.yggdrasil.nixos.ipv6.address}]";
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
