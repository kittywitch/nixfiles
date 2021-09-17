{ config, pkgs, lib, tf, ... }: with lib; {
  kw.secrets.variables = mapListToAttrs
    (field:
      nameValuePair "ttrss-${field}" {
        path = "secrets/ttrss";
        inherit field;
      }) [ "password" "ldap" ];

  secrets.files = {
    ttrss-ldap-password = {
      text = tf.variables.ttrss-ldap.ref;
      owner = "tt_rss";
      group = "tt_rss";
    };
  };
  secrets.files = {
    ttrss-db-password = {
      text = tf.variables.ttrss-password.ref;
      owner = "tt_rss";
      group = "tt_rss";
    };
  };

  deploy.tf.dns.records.services_ttrss = {
    inherit (config.network.dns) zone;
    domain = "rss";
    cname = { inherit (config.network.addresses.public) target; };
  };

  services.tt-rss = {
    enable = true;
    virtualHost = "rss.kittywit.ch";
    selfUrlPath = "https://rss.kittywit.ch";

    pluginPackages = [
      pkgs.tt-rss-plugin-auth-ldap
    ];
    themePackages = [
      pkgs.tt-rss-theme-feedly
    ];
    plugins = [
      "auth_internal"
      "auth_ldap"
      "note"
      "updater"
      "api_feedreader"
    ];

    database = {
      createLocally = true;
      type = "pgsql";
      host = "/run/postgresql";
    };

    extraConfig = ''
      putenv('LDAP_DB_PASS=' . file_get_contents("${config.secrets.files.ttrss-db-password.path}"));
      define('LDAP_AUTH_SERVER_URI', 'ldap://127.0.0.1:389/');
      define('LDAP_AUTH_USETLS', FALSE); // Enable TLS Support for ldaps://
      define('LDAP_AUTH_ALLOW_UNTRUSTED_CERT', FALSE); // Allows untrusted certificate
      define('LDAP_AUTH_BINDDN', 'cn=root,dc=kittywit,dc=ch');
      define('LDAP_AUTH_BINDPW', file_get_contents('${config.secrets.files.ttrss-ldap-password.path}'));
      define('LDAP_AUTH_BASEDN', 'ou=users,dc=kittywit,dc=ch');
      define('LDAP_AUTH_LOGIN_ATTRIB', 'mail');
      define('LDAP_AUTH_ANONYMOUSBEFOREBIND', FALSE);
      // ??? will be replaced with the entered username(escaped) at login
      define('LDAP_AUTH_SEARCHFILTER', '(&(objectClass=inetOrgPerson)(mail=???))');
      // Optional configuration
      define('LDAP_AUTH_LOG_ATTEMPTS', TRUE);
      // Enable Debug Logging
      define('LDAP_AUTH_DEBUG', TRUE);
    '';
  };

  services.nginx = {
    virtualHosts."rss.kittywit.ch" = {
      enableACME = true;
      forceSSL = true;
    };
  };
}
