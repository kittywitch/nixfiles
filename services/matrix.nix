{ config, pkgs, witch, ... }:

{
  environment.systemPackages = [ pkgs.mx-puppet-discord pkgs.mautrix-whatsapp ];

  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
    TEMPLATE template0
    LC_COLLATE = "C"
    LC_CTYPE = "C";
  '';

  services.matrix-synapse = {
    enable = true;
    registration_shared_secret = witch.secrets.hosts.athame.matrix_secret;
    max_upload_size = "512M";
    server_name = "kittywit.ch";
    app_service_config_files = [
      "/var/lib/matrix-synapse/telegram-registration.yaml"
      "/var/lib/matrix-synapse/discord-registration.yaml"
      "/var/lib/matrix-synapse/whatsapp-registration.yaml"
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

  secrets.files = {
    telegram-env = { source = ../private/files/matrix/mautrix-telegram.env; };
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
          "kittywit.ch" = "full";
        };
      };
    };
    environmentFile = config.secrets.files.telegram-env.path;
  };

  systemd.services.mx-puppet-discord = {
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart =
        "${pkgs.arc.pkgs.mx-puppet-discord}/bin/mx-puppet-discord -c /var/lib/mx-puppet-discord/config.yaml -f /var/lib/mx-puppet-discord/discord-registration.yaml";
      WorkingDirectory = "/var/lib/mx-puppet-discord";
      DynamicUser = true;
      StateDirectory = "mx-puppet-discord";
      UMask = 27;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
    };
    requisite = [ "matrix-synapse.service" ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
  };

  systemd.services.mautrix-whatsapp = {
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart =
        "${pkgs.mautrix-whatsapp}/bin/mautrix-whatsapp -c /var/lib/mautrix-whatsapp/config.yaml -r /var/lib/mautrix-whatsapp/registration.yaml";
      WorkingDirectory = "/var/lib/mautrix-whatsapp";
      DynamicUser = true;
      StateDirectory = "mautrix-whatsapp";
      UMask = 27;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
    };
    requisite = [ "matrix-synapse.service" ];
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
  };

  services.nginx.virtualHosts."kittywit.ch" = {
    locations = {
      "/_matrix" = { proxyPass = "http://[::1]:8008"; };
      "= /.well-known/matrix/server".extraConfig =
        let server = { "m.server" = "kittywit.ch:443"; };
        in ''
          add_header Content-Type application/json;
          return 200 '${builtins.toJSON server}';
        '';
      "= /.well-known/matrix/client".extraConfig = let
        client = {
          "m.homeserver" = { "base_url" = "https://kittywit.ch"; };
          "m.identity_server" = { "base_url" = "https://vector.im"; };
        };
      in ''
        add_header Content-Type application/json;
        add_header Access-Control-Allow-Origin *;
        return 200 '${builtins.toJSON client}';
      '';
    };
  };
}
