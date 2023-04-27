_: {
  services.nginx.virtualHosts."vault.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations = {
      "/" = {
        proxyPass = "http://localhost:4000";
        proxyWebsockets = true;
      };
      "/notifications/hub" = {
        proxyPass = "http://localhost:3012";
        proxyWebsockets = true;
      };
      "/notifications/hub/negotiate" = {
        proxyPass = "http://localhost:4000";
        proxyWebsockets = true;
      };
    };
  };
}
