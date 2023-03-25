{ config, lib, ... }: let
  inherit (lib) mapAttrs' nameValuePair splitString last;
  inherit (config) services;
  inherit (services.kanidm.serverSettings) domain;
in {
  sops.secrets.cloudflared-tunnel-apartment.owner = services.cloudflared.user;
  services.cloudflared = {
    enable = true;
    tunnels = {
      "a3ae32ce-fe82-4f2c-ad54-3adf4a45fcbc" = {
        credentialsFile = config.sops.secrets.cloudflared-tunnel-apartment.path;
        default = "http_status:404";
        ingress = mapAttrs' (prefix: nameValuePair "${prefix}${domain}") {
          "" = "http://localhost:80";
          "home." = "http://localhost:${toString services.home-assistant.config.http.server_port}";
          "z2m." = "http://localhost:80";
          "login." = "http://localhost:${toString services.vouch-proxy.settings.vouch.port}";
          "id." = let
            inherit (services.kanidm.serverSettings) bindaddress;
            port = last (splitString ":" bindaddress);
          in {
            service = "https://127.0.0.1:${port}";
            originRequest.noTLSVerify = true;
          };
        };
      };
    };
  };
}
