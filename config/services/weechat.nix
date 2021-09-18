{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."irc.${config.network.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = { root = pkgs.glowing-bear; };
      "^~ /weechat" = {
        proxyPass = "http://127.0.0.1:9000";
        proxyWebsockets = true;
      };
    };
  };

  deploy.tf.dns.records.services_weechat = {
    inherit (config.network.dns) zone;
    domain = "irc";
    cname = { inherit (config.network.addresses.public) target; };
  };
}
