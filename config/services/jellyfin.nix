{ config, lib, pkgs, kw, ... }:

{
  services.nginx.virtualHosts = kw.virtualHostGen {
    networkFilter = [ "private" "yggdrasil" ];
    block.locations = {
      "/jellyfin/".proxyPass = "http://127.0.0.1:8096/jellyfin/";
      "/jellyfin/socket" = {
        proxyPass = "http://127.0.0.1:8096/jellyfin/";
        extraConfig = ''
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
        '';
      };
    };
  };

  network.firewall = {
    public.tcp.ranges = [{
      from = 32768;
      to = 60999;
    }];
    private.tcp = {
      ports = [
        8096
      ];
      ranges = [{
        from = 32768;
        to = 60999;
      }];
    };
  };

  services.jellyfin.enable = true;
}
