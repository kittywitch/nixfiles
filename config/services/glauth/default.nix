{ config, tf, lib, ... }: with lib; {
  services.glauth = {
    enable = true;
    configFile = config.secrets.files.glauth-config-file.path;
    database = {
      enable = true;
      local = true;
      type = "postgres";
      passwordFile = config.secrets.files.glauth-postgres-file.path;
    };
    settings = {
      syslog = true;
      ldap = {
        enable = false;
        listen = "0.0.0.0:3893";
      };
      ldaps = {
        enabled = true;
        listen = "0.0.0.0:3894";
        cert = "/var/lib/acme/auth.kittywit.ch/fullchain.pem";
        key = "/var/lib/acme/auth.kittywit.ch/key.pem";
      };
      backend = {
        baseDN = "dc=kittywitch,dc=com";
      };
      users = [{
        name = "kat";
        passsha256 = tf.variables.glauth-password-hash.ref;
        uidnumber = 1000;
        primarygroup = 1500;
      }];
      groups = [{
        name = "admins";
        gidnumber = 1500;
      }];
    };
  };

  kw.secrets.variables = mapListToAttrs (field:
    nameValuePair "glauth-${field}" {
      path = "services/glauth";
      inherit field;
    }) ["password-hash" "postgres"];

  secrets.files = {
    glauth-postgres-file = {
      text = tf.variables.glauth-postgres.ref;
      owner = "glauth";
      group = "glauth";
    };
    glauth-config-file = {
      text = config.services.glauth.outTOML;
      owner = "glauth";
      group = "glauth";
    };
  };
}
