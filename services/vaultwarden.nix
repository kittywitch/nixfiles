{ config, pkgs, lib, tf, ... }: with lib;

{
  secrets.variables = mapListToAttrs (field:
    nameValuePair "vaultwarden-${field}" {
      path = "secrets/vaultwarden";
      inherit field;
    }) [ "password" "smtp" ];

  secrets.files.vaultwarden-env = {
    text = ''
      ADMIN_TOKEN=${tf.variables.vaultwarden-password.ref}
      SMTP_HOST=daiyousei.kittywit.ch
      SMTP_FROM=vaultwarden@kittywit.ch
      SMTP_FROM_NAME=Vaultwarden
      SMTP_PORT=465
      SMTP_SSL=true
      SMTP_EXPLICIT_TLS=true
      SMTP_USERNAME=vaultwarden@kittywit.ch
      SMTP_PASSWORD=${tf.variables.vaultwarden-smtp.ref}
    '';
    owner = "bitwarden_rs";
    group = "bitwarden_rs";
  };

  services.vaultwarden = {
    environmentFile = config.secrets.files.vaultwarden-env.path;
  };

  services.postgresql = {
    ensureDatabases = [ "bitwarden_rs" ];
    ensureUsers = [{
      name = "bitwarden_rs";
      ensurePermissions = { "DATABASE bitwarden_rs" = "ALL PRIVILEGES"; };
    }];
  };

  users.users.vaultwarden.name = "bitwarden_rs";
  users.groups.vaultwarden.name = "bitwarden_rs";

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    config = {
      rocketPort = 4000;
      websocketEnabled = true;
      signupsAllowed = false;
      domain = "https://vault.kittywit.ch}";
      databaseUrl = "postgresql://bitwarden_rs@/bitwarden_rs";
    };
  };

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

  domains.kittywitch-vault = {
    network = "internet";
    type = "cname";
    domain = "vault";
  };
}
