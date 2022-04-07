
{ config, lib, meta, ... }: with lib; {
  deploy.tf.dns.records.services_home = {
    inherit (config.network.dns) zone;
    domain = "home";
    cname = { inherit (config.network.addresses.public) target; };
  };

  services.nginx.virtualHosts = {
      "home.${config.network.dns.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://home.int.kittywit.ch:80/";
            extraConfig = ''
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
            '';
          };
        };
      };
    };
}
