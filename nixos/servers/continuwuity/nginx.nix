_: {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };
  services.nginx.virtualHosts."rinnosuke.inskip.me" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/_matrix" = {
        proxyPass = "http://127.0.0.1:6167$request_uri";
        proxyWebsockets = true;
      };
    };
  };
}
