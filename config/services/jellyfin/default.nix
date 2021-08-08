{ config, lib, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "${config.networking.hostName}.${config.kw.dns.ygg_prefix}.${config.kw.dns.domain}".locations = {
        "/jellyfin/".proxyPass = "http://[::1]:8096/jellyfin/";
        "/jellyfin/socket" = {
          proxyPass = "http://[::1]:8096/jellyfin/";
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
    };
    ${config.kw.dns.ipv4}.locations = {
        "/jellyfin/".proxyPass = "http://[::1]:8096/jellyfin/";
        "/jellyfin/socket" = {
          proxyPass = "http://[::1]:8096/jellyfin/";
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
    };
  };

  kw.fw = {
    public.tcp.ranges = [{
      from = 32768;
      to = 60999;
    }];
    private.tcp.ranges = [{
      from = 32768;
      to = 60999;
    }];
  };

  services.jellyfin.enable = true;
}
