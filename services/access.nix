{ config, lib, meta, pkgs, tf, ... }: with lib; {

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
    gensokyo-home = {
      network = "internet";
      type = "cname";
      domain = "home";
      zone = "gensokyo.zone.";
    };
    gensokyo-kanidm = {
      network = "internet";
      type = "cname";
      domain = "id";
      zone = "gensokyo.zone.";
    };
    gensokyo-vouch = {
      network = "internet";
      type = "cname";
      domain = "login";
      zone = "gensokyo.zone.";
    };
    gensokyo-z2m = {
      network = "internet";
      type = "cname";
      domain = "z2m";
      zone = "gensokyo.zone.";
    };
    gensokyo-root = {
      network = "internet";
      type = "both";
      domain = "@";
      zone = "gensokyo.zone.";
    };
  };

  services.nginx.virtualHosts = mkMerge [
  (mkIf (tf.state.enable && config.networking.hostName == "tewi") {
    "gensokyo.zone" = {
      locations."/" = {
        root = pkgs.gensokyoZone;
      };
    };
    "z2m.gensokyo.zone" = {
      extraConfig = ''
        auth_request /validate;
        error_page 401 = @error401;
      '';
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8072";
          extraConfig = ''
            add_header Access-Control-Allow-Origin https://login.gensokyo.zone;
            add_header Access-Control-Allow-Origin https://id.gensokyo.zone;
            proxy_set_header X-Vouch-User $auth_resp_x_vouch_user;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_http_version 1.1;
          '';
        };
        "@error401" = {
          extraConfig = ''
            return 302 https://login.gensokyo.zone/login?url=$scheme://$http_host$request_uri&vouch-failcount=$auth_resp_failcount&X-Vouch-Token=$auth_resp_jwt&error=$auth_resp_err;
          '';
        };
        "/validate" = {
          recommendedProxySettings = false;
          proxyPass = "http://127.0.0.1:30746/validate";
          extraConfig = ''
            proxy_set_header Host $http_host;
            proxy_pass_request_body off;
            proxy_set_header Content-Length "";
            auth_request_set $auth_resp_x_vouch_user $upstream_http_x_vouch_user;
            auth_request_set $auth_resp_jwt $upstream_http_x_vouch_jwt;
            auth_request_set $auth_resp_err $upstream_http_x_vouch_err;
            auth_request_set $auth_resp_failcount $upstream_http_x_vouch_failcount;
          '';
        };
      };
    };
  })
  (mkIf (config.networking.hostName != "tewi") {
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
    "cloud.kittywit.ch" = {
      locations = {
        "/".proxyPass = meta.tailnet.yukari.ppp 4 80 "nextcloud/";
      };
    };
    "plex.kittywit.ch" = {
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
  })
  ];
}
