{ config, pkgs, ... }:

let secrets = (import ../secrets.nix);
in {
  services.matrix-synapse = {
    enable = true;
    registration_shared_secret = secrets.matrix.secret;
    server_name = "kittywit.ch";
    app_service_config_files = [
      "/var/lib/matrix-synapse/telegram-registration.yaml"
    ];
    listeners = [{
      port = 8008;
      bind_address = "::1";
      type = "http";
      tls = false;
      x_forwarded = true;
      resources = [{
        names = [ "client" "federation" ];
        compress = false;
      }];
    }];
  };
  services.mautrix-telegram = {
    enable = true;
    settings = {
      homeserver = {
        address = "http://localhost:8008";
        domain = "kittywit.ch";
      };
      appservice = {
        provisioning.enabled = false;
        id = "telegram";
        public = {
          enabled = false;
          prefix = "/public";
          external = "https://kittywit.ch/public";
        };
      };
      bridge = {
        relaybot.authless_portals = false;
        permissions = {
        "@kat:kittywit.ch" = "admin";
        };
      };
    };
    environmentFile = "/etc/secrets/mautrix-telegram.env";
  };
}
