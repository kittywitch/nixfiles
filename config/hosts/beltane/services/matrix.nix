{ config, pkgs, ... }:

let secrets = (import ../secrets.nix);
in {
  environment.systemPackages = [
    pkgs.arc.pkgs.mx-puppet-discord
    pkgs.mautrix-whatsapp
  ];

  services.matrix-synapse = {
    enable = true;
    registration_shared_secret = secrets.matrix.secret;
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
  systemd.services.mx-puppet-discord = {
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart = "${pkgs.arc.pkgs.mx-puppet-discord}/bin/mx-puppet-discord -c /var/lib/mx-puppet-discord/config.yaml -f /var/lib/mx-puppet-discord/discord-registration.yaml";
      WorkingDirectory = "/var/lib/mx-puppet-discord";
      DynamicUser = true;
      StateDirectory = "mx-puppet-discord";
      UMask = 0027;
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
      ExecStart = "${pkgs.mautrix-whatsapp}/bin/mautrix-whatsapp -c /var/lib/mautrix-whatsapp/config.yaml -r /var/lib/mautrix-whatsapp/registration.yaml";
      WorkingDirectory = "/var/lib/mautrix-whatsapp";
      DynamicUser = true;
      StateDirectory = "mautrix-whatsapp";
      UMask = 0027;
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
}
