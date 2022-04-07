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

  systemd.services = {
      jellyfin-socat =
        let
          service = lib.singleton "jellyfin.service";
        in
        {
          after = service;
          bindsTo = service;
          serviceConfig = {
            DynamicUser = true;
          };
          script =
            let
              port = toString 8096;
              addr = config.network.addresses.yggdrasil.nixos.ipv6.address;
            in "${pkgs.socat}/bin/socat TCP6-LISTEN:${port},bind=${addr},fork TCP4:localhost:${port}";
        };
      };

  network.firewall = {
    public.tcp.ranges = [{
      from = 32768;
      to = 60999;
    }];
    public.tcp.ports = [ 8096 ];
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
