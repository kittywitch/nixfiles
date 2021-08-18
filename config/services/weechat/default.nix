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
    tld = config.network.dns.tld;
    domain = "irc";
    cname.target = "${config.networking.hostName}.${config.network.dns.tld}";
  };
}
