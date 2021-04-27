{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."irc.kittywit.ch" = {
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

  deploy.tf.dns.records.kittywitch_irc = {
    tld = "kittywit.ch.";
    domain = "irc";
    cname.target = "athame.kittywit.ch.";
  };
}
