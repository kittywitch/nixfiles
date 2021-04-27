{ config, lib, ... }:

with lib;

{
  katnet.private.tcp.ports = singleton 1935;
  katnet.public.tcp.ports = singleton 1935;

  services.nginx.virtualHosts = {
    "samhain.net.kittywit.ch" = {
      useACMEHost = "samhain.net.kittywit.ch";
      forceSSL = true;
      locations = {
        "/jellyfin/".proxyPass = "http://127.0.0.1:8096/jellyfin/";
        "/jellyfin/socket" = {
          proxyPass = "http://127.0.0.1:8096/jellyfin/";
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
        "/" = {
          root = "/mnt/zraw/media/";
          extraConfig = "autoindex on;";
        };
        "/transmission" = {
          proxyPass = "http://[::1]:9091";
          extraConfig = "proxy_pass_header  X-Transmission-Session-Id;";
        };
      };
    };
    "192.168.1.135" = {
      locations = {
        "/jellyfin/".proxyPass = "http://127.0.0.1:8096/jellyfin/";
        "/jellyfin/socket" = {
          proxyPass = "http://127.0.0.1:8096/jellyfin/";
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };

        "/share/" = {
          alias = "/mnt/zraw/media/";
          extraConfig = "autoindex on;";
        };
      };
    };
    "100.103.111.44" = {
      locations."/share/" = {
        alias = "/mnt/zraw/media/";
        extraConfig = "autoindex on;";
      };
    };
  };

  services.nginx.appendConfig = ''
    rtmp {
      server {
        listen [::]:1935 ipv6only=off;
        application kattv {
          live on;

          allow publish all;
          allow play all;
        }
      }
    }
  '';
}
