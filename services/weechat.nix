{ config, pkgs, ... }:

{
  services.nginx.virtualHosts."irc.kittywit.ch" = {
    locations = {
      "/" = { root = pkgs.glowing-bear; };
      "^~ /weechat" = {
        proxyPass = "http://127.0.0.1:9000";
        proxyWebsockets = true;
      };
    };
  };

  domains.kittywitch_irc = {
    network = "internet";
    domain = "irc";
    type = "cname";
  };

}
