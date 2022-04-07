{ config, kw, pkgs, lib, ... }: {
  services = {
    plex = {
      enable = true;
      package = pkgs.plex.overrideAttrs (x: let
        # see https://www.plex.tv/media-server-downloads/ for 64bit rpm
        version = "1.25.9.5721-965587f64";
        sha256 = "sha256-NPfpQ8JwXDaq8xpvSabyqdDqMWjoqbeoJdu41nhdsI0=";
      in {
        name = "plex-${version}";
        src = pkgs.fetchurl {
          url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
          inherit sha256;
        };
      }
      );
    };

    nginx.virtualHosts."plex.kittywit.ch".locations."/" = {
      proxyPass = "http://127.0.0.1:32400";
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
}
