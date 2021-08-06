{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."irc.${config.kw.dns.domain}" = {
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
    tld = config.kw.dns.tld;
    domain = "irc";
    cname.target = "${config.networking.hostName}.${config.kw.dns.tld}";
  };
}
