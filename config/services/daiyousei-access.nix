
{ config, lib, meta, ... }: with lib; {
  deploy.tf.dns.records.services_home = {
    inherit (config.network.dns) zone;
    domain = "home";
    a = { inherit (config.network.addresses.public.tf.ipv4) address; };
  };

  services.nginx.virtualHosts = {
      "home.${config.network.dns.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://home.int.kittywit.ch:8123";
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
            '';
          };
        };
      };
    };
}
