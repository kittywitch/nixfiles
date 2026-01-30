{ config, inputs, ... }: let
  domain = "dork.dev";
in {
    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          root = inputs.kusachi.packages.x86_64-linux.kusachi-site;
        };
      };
    };
}
