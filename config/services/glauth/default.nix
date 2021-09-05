{ config, tf, lib, ... }: with lib; {
  network.firewall.public.tcp.ports = [ 3984 ];

  network.extraCerts.domain-auth = "auth.${config.network.dns.domain}";
  users.groups.domain-auth.members = [ "nginx" "glauth" ];
  security.acme.certs.domain-auth.group = "domain-auth";

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
        enabled = false;
        listen = "0.0.0.0:3893";
      };
      ldaps = {
        enabled = true;
        listen = "0.0.0.0:3894";
        cert = "/var/lib/acme/domain-auth/fullchain.pem";
        key = "/var/lib/acme/domain-auth/key.pem";
      };
      backend = {
        baseDN = "dc=kittywitc,dc=ch";
      };
      users = [
        {
          name = "kat";
          passsha256 = tf.variables.glauth-password-hash.ref;
          uidnumber = 1000;
          primarygroup = 1500;
        }
        {
          name = "kc";
          passsha256 = tf.variables.glauth-kc-password-hash.ref;
          uidnumber = 1001;
          primarygroup = 1500;
        }
      ];
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
    }) ["password-hash" "kc-password-hash" "postgres"];

  secrets.files = {
    glauth-postgres-file = {
      text = tf.variables.glauth-postgres.ref;
      owner = "postgres";
      group = "glauth";
    };
    glauth-config-file = {
      text = toTOML config.services.glauth.settings;
      owner = "glauth";
      group = "glauth";
    };
  };
}
