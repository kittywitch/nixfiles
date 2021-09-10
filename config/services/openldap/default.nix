{ config, pkgs, tf, lib, ... }: with lib; {
  network.firewall.public.tcp.ports = [ 636 ];

  services.openldap = {
    enable = true;
    urlList = [ "ldap:///" "ldapi:///" "ldaps:///" ];
    settings = {
      attrs = {
        objectClass = "olcGlobal";
        cn = "config";
        olcPidFile = "/run/slapd/slapd.pid";
        olcTLSCACertificateFile = "/var/lib/acme/domain-auth/fullchain.pem";
        olcTLSCertificateFile = "/var/lib/acme/domain-auth/cert.pem";
        olcTLSCertificateKeyFile = "/var/lib/acme/domain-auth/key.pem";
      };
      children = {
        "cn=schema" = {
          attrs = {
            cn = "schema";
            objectClass = "olcSchemaConfig";
          };
          includes = [
          "${pkgs.openldap}/etc/schema/core.ldif"
          "${pkgs.openldap}/etc/schema/cosine.ldif"
          "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
          "${pkgs.openldap}/etc/schema/nis.ldif"
          ];
        };
        "olcDatabase={-1}frontend" = {
          attrs = {
            objectClass = [
              "olcDatabaseConfig"
              "olcFrontendConfig"
            ];
            olcDatabase = "{-1}frontend";
            olcAccess = [
              "{0}to * by dn.exact=gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth manage by * break"
              "{1}to dn.exact=\"\" by * read"
              "{2}to dn.base=\"cn=Subschema\" by * read"
            ];
          };
        };
        "olcDatabase={0}config" = {
          attrs = {
            objectClass = "olcDatabaseConfig";
            olcDatabase = "{0}config";
            olcAccess = [ "{0}to * by * none break" ];
          };
        };
        "olcDatabase={1}mdb" = {
          attrs = {
            objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
            olcDatabase = "{1}mdb";
            olcDbDirectory = "/var/db/ldap";
            olcSuffix = "dc=kittywit,dc=ch";
            olcRootDN = "cn=root,dc=kittywit,dc=ch";
            olcRootPW.path = config.secrets.files.openldap-root-password-file.path;
            olcAccess = [
              "{0}to attrs=userPassword
                by anonymous auth
                by self write
                by * none"
              "{1}to *
                by dn.children=\"ou=users,dc=kittywit,dc=ch\" write
                by self read by * none"
              "{2}to dn.subtree=\"dc=kittywit,dc=ch\"
              by dn.exact=\"cn=root,dc=kittywit,dc=ch\" manage"
            ];
          };
        };
      };
    };
  };


  kw.secrets.variables = mapListToAttrs
    (field:
      nameValuePair "openldap-${field}" {
        path = "services/openldap";
        inherit field;
      }) [ "password" ];

  secrets.files = {
    openldap-root-password-file = {
      text = tf.variables.openldap-password.ref;
      owner = "openldap";
      group = "openldap";
    };
  };
}
