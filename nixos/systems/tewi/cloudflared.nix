{ config, lib, ... }: with lib; {
  sops.secrets.cloudflared-tunnel-apartment.owner = config.services.cloudflared.user;
  services.cloudflared = {
    enable = true;
    tunnels = {
      "a3ae32ce-fe82-4f2c-ad54-3adf4a45fcbc" = {
        credentialsFile = config.sops.secrets.cloudflared-tunnel-apartment.path;
        default = "http_status:404";
        ingress = {
          "gensokyo.zone" = "http://localhost:80";
          "home.gensokyo.zone" = "http://localhost:8123";
          "z2m.gensokyo.zone" = "http://localhost:80";
          "login.gensokyo.zone" = "http://localhost:${toString config.services.vouch-proxy.settings.vouch.port}";
          "id.gensokyo.zone" = {
            service = "https://127.0.0.1:8081";
            originRequest.noTLSVerify = true;
          };
        };
      };
    };
  };
}
