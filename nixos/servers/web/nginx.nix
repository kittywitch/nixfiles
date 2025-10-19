{config, ...}: {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    statusPage = true;
    virtualHosts = let
      vHost = {
        extraConfig = ''
          add_header Content-Type text/plain;
          return 200 "meep?";
        '';
        /*
          locations = {
          "/" = {
            extraConfig = ''
              add_header Content-Type text/plain;
              return 200 "meep?";
            '';
          };
        };
        */
      };
    in {
      "${config.networking.fqdn}" =
        vHost
        // {
          enableACME = true;
          forceSSL = true;
          default = true;
        };
      "localhost" = vHost;
    };
  };
}
