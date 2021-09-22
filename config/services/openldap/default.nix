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
        "cn=module" = {
          attrs = {
            objectClass = "olcModuleList";
            olcModuleLoad = "memberof";
          };
        };
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
        "olcOverlay=memberof,olcDatabase={1}mdb" = {
          attrs = {
            objectClass = [
              "olcOverlayConfig"
              "olcMemberOf"
              "olcConfig"
            ];
            olcOverlay = "memberof";
            olcMemberOfDangling = "ignore";
            olcMemberOfGroupOC = "groupOfNames";
            olcMemberOfMemberAD = "member";
            olcMemberOfMemberOfAD = "memberOf";
            olcMemberOfRefint = "TRUE";
          };
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
              ''{0}to attrs=userPassword
                by anonymous auth
                by dn.base="cn=dovecot,dc=mail,dc=kittywit,dc=ch" read
                by dn.subtree="ou=services,dc=kittywit,dc=ch" read
                by self write
                by * none''
                ''{1}to dn.subtree="dc=kittywit,dc=ch"
                  by dn.exact="cn=root,dc=kittywit,dc=ch" manage
                  by dn.base="cn=dovecot,dc=mail,dc=kittywit,dc=ch" read
                  by dn.subtree="ou=services,dc=kittywit,dc=ch" read
                  by dn.subtree="ou=users,dc=kittywit,dc=ch" read
                ''
              ''{2}to dn.subtree="ou=users,dc=kittywit,dc=ch"
                   by dn.base="cn=dovecot,dc=mail,dc=kittywit,dc=ch" read
                   by dn.subtree="ou=users,dc=kittywit,dc=ch" read
                   by dn.subtree="ou=services,dc=kittywit,dc=ch" read
                     by * none''
              ''{3}to dn.subtree="ou=services,dc=kittywit,dc=ch"
                   by dn.base="cn=dovecot,dc=mail,dc=kittywit,dc=ch" read
                   by dn.subtree="ou=services,dc=kittywit,dc=ch" read
                       by * none''
              ''{4}to dn.subtree="ou=groups,dc=kittywit,dc=ch"
                  by dn.subtree="ou=users,dc=kittywit,dc=ch" read
                  by dn.subtree="ou=services,dc=kittywit,dc=ch" read
                       by * none''
              ''{5}to attrs=mail by self read''
              ''{6}to * by * read''
            ];
          };
        };
        "cn={2}postfix,cn=schema".attrs = {
          cn = "{2}postfix";
          objectClass = "olcSchemaConfig";
          olcAttributeTypes = [
            ''( 1.3.6.1.4.1.4203.666.1.200 NAME 'mailAcceptingGeneralId'
              EQUALITY caseIgnoreIA5Match
              SUBSTR caseIgnoreIA5SubstringsMatch
              SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{256} )''
            ''(1.3.6.1.4.1.12461.1.1.1 NAME 'postfixTransport'
               DESC 'A string directing postfix which transport to use'
               EQUALITY caseExactIA5Match
               SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{20} SINGLE-VALUE)''
            ''(1.3.6.1.4.1.12461.1.1.5 NAME 'mailbox'
               DESC 'The absolute path to the mailbox for a mail account in a non-default location'
               EQUALITY caseExactIA5Match
               SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE)''
            ''(1.3.6.1.4.1.12461.1.1.6 NAME 'quota'
               DESC 'A string that represents the quota on a mailbox'
               EQUALITY caseExactIA5Match
               SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE)''
            ''(1.3.6.1.4.1.12461.1.1.8 NAME 'maildrop'
               DESC 'RFC822 Mailbox - mail alias'
               EQUALITY caseIgnoreIA5Match
               SUBSTR caseIgnoreIA5SubstringsMatch
               SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{256})''
          ];
          olcObjectClasses = [
            ''(1.3.6.1.4.1.12461.1.2.1 NAME 'mailAccount'
               SUP top AUXILIARY
               DESC 'Mail account objects'
               MUST ( mail $ userPassword )
               MAY (  cn $ description $ quota))''
            ''(1.3.6.1.4.1.12461.1.2.2 NAME 'mailAlias'
               SUP top STRUCTURAL
               DESC 'Mail aliasing/forwarding entry'
               MUST ( mail $ maildrop )
               MAY ( cn $ description ))''
            ''(1.3.6.1.4.1.12461.1.2.3 NAME 'mailDomain'
               SUP domain STRUCTURAL
               DESC 'Virtual Domain entry to be used with postfix transport maps'
               MUST ( dc )
               MAY ( postfixTransport $ description  ))''
            ''(1.3.6.1.4.1.12461.1.2.4 NAME 'mailPostmaster'
               SUP top AUXILIARY
               DESC 'Added to a mailAlias to create a postmaster entry'
               MUST roleOccupant)''
          ];
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
