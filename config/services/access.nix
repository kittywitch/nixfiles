{ config, lib, meta, ... }: {
  deploy.tf.dns.records.services_media_forward = {
    inherit (config.network.dns) zone;
    domain = "media";
    cname = { inherit (config.network.addresses.public) target; };
  };

  deploy.tf.dns.records.services_owncast = {
    inherit (config.network.dns) zone;
    domain = "cast";
    cname = { inherit (config.network.addresses.public) target; };
  };

  services.nginx.virtualHosts = {
    "cast.${config.network.dns.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/".proxyPass = "http://127.0.0.1:8082";
      };
    };
    "media.${config.network.dns.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/jellyfin/".proxyPass = "http://${meta.network.nodes.yukari.network.addresses.wireguard.nixos.ipv4.address}:8096/jellyfin/";
        "/jellyfin/socket" = {
          proxyPass = "http://${meta.network.nodes.yukari.network.addresses.wireguard.nixos.ipv4.address}:8096/jellyfin/";
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
      };
    };
  };
}
