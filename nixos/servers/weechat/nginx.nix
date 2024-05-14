{ pkgs, ... }: {
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
}