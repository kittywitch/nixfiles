{ config, pkgs, lib, tf, ... }: with lib;

let
  settings = {
    database = {
      inherit (config.services.vikunja.database) type host user database path;
    };
    service = {
      frontendurl = "${config.services.vikunja.frontendScheme}://${config.services.vikunja.frontendHostname}/";
      JWTSecret = tf.variables.vikunja-jwt.ref;
      timezone = "Europe/London";
    };
    mailer = {
      enabled = true;
      host = "daiyousei.kittywit.ch";
      port = 465;
      forcessl = true;
      username = "vikunja@kittywit.ch";
      password = tf.variables.vikunja-email.ref;
      fromemail = "vikunja@kittywit.ch";
    };
    files = {
        basepath = "/var/lib/vikunja/files";
    };
    log.http = "off";
    auth = {
      local = {
        enabled = false;
      };
      openid = {
        enabled = true;
        providers = [{
          name = "keycloak";
          authurl = "https://auth.kittywit.ch/auth/realms/kittywitch";
          clientid = "vikunja";
          clientsecret = tf.variables.vikunja-secret.ref;
        }];
      };
    };
  };
in {

  kw.secrets.variables = (mapListToAttrs
    (field:
      nameValuePair "vikunja-${field}" {
        path = "secrets/vikunja";
        inherit field;
      }) [ "secret" "email" "jwt" ]);

  secrets.files.vikunja-config = {
    text = builtins.toJSON settings;
    owner = "vikunja";
    group = "vikunja";
  };

  deploy.tf.dns.records.services_vikunja = {
    inherit (config.network.dns) zone;
    domain = "todo";
    cname = { inherit (config.network.addresses.public) target; };
  };

  environment.etc."vikunja/config.yaml".source = mkForce config.secrets.files.vikunja-config.path;

  services.vikunja = {
    enable = true;
    frontendScheme = "https";
    frontendHostname = "todo.${config.network.dns.domain}";
    database = {
      type = "postgres";
      user = "vikunja";
      database = "vikunja";
      host = "/run/postgresql";
    };
  };
  services.nginx.virtualHosts."${config.services.vikunja.frontendHostname}" = {
    enableACME = true;
    forceSSL = true;
  };

  services.postgresql = {
    ensureDatabases = [ "vikunja" ];
    ensureUsers = [
      { name = "vikunja";
        ensurePermissions = { "DATABASE vikunja" = "ALL PRIVILEGES"; };
      }
    ];
  };

  systemd.services.vikunja-api = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "vikunja";
      Group = "vikunja";
    };
  };

  users.users.vikunja = {
    description = "Vikunja Service";
    createHome = false;
    group = "vikunja";
    isSystemUser = true;
  };

  users.groups.vikunja = {};
}
