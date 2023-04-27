_: {
  services.nginx.virtualHosts."vault.kittywit.ch" = {
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
