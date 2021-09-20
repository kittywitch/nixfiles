{ pkgs, config, lib, tf, ... }: with lib;
let
  ldapConfig = pkgs.writeText "dovecot-ldap.conf" ''
    uris = ldaps://auth.kittywit.ch:636
    dn = cn=dovecot,dc=mail,dc=kittywit,dc=ch
    dnpass = "@ldap-password@"
    auth_bind = no
    ldap_version = 3
    base = ou=users,dc=kittywit,dc=ch
    user_filter = (&(objectClass=mailAccount)(|(mail=%u)(uid=%u)))
    user_attrs = \
      quota=quota_rule=*:bytes=%$, \
      =home=/var/vmail/%d/%n/, \
      =mail=maildir:/var/vmail/%d/%n/Maildir
    pass_attrs = mail=user,userPassword=password
    pass_filter = (&(objectClass=mailAccount)(mail=%u))
    iterate_attrs = =user=%{ldap:mail}
    iterate_filter = (objectClass=mailAccount)
    scope = subtree
    default_pass_scheme = SSHA
  '';
  ldapConfig-services = pkgs.writeText "dovecot-ldap.conf" ''
    uris = ldaps://auth.kittywit.ch:636
    dn = cn=dovecot,dc=mail,dc=kittywit,dc=ch
    dnpass = "@ldap-password@"
    auth_bind = no
    ldap_version = 3
    base = ou=services,dc=kittywit,dc=ch
    user_filter = (&(objectClass=mailAccount)(|(mail=%u)(uid=%u)))
    user_attrs = \
      quota=quota_rule=*:bytes=%$, \
      =home=/var/vmail/%d/%n/, \
      =mail=maildir:/var/vmail/%d/%n/Maildir
    pass_attrs = mail=user,userPassword=password
    pass_filter = (&(objectClass=mailAccount)(mail=%u))
    iterate_attrs = =user=%{ldap:mail}
    iterate_filter = (objectClass=mailAccount)
    scope = subtree
    default_pass_scheme = SSHA
  '';
in
{
  security.acme.certs.dovecot_domains = {
    inherit (config.network.dns) domain;
    group = "postfix";
    dnsProvider = "rfc2136";
    credentialsFile = config.secrets.files.dns_creds.path;
    postRun = "systemctl restart dovecot2";
    extraDomainNames =
      [
        config.network.dns.domain
        "mail.${config.network.dns.domain}"
        config.network.addresses.public.domain
        "dork.dev"
      ];
    };

  services.dovecot2 = {
    enable = true;
    enableImap = true;
    enableLmtp = true;
    enablePAM = false;
    mailLocation = "maildir:/var/vmail/%d/%n/Maildir";
    mailUser = "vmail";
    mailGroup = "vmail";
    extraConfig = ''
      ssl = yes
      ssl_cert = </var/lib/acme/dovecot_domains/fullchain.pem
      ssl_key = </var/lib/acme/dovecot_domains/key.pem
      local_name kittywit.ch {
        ssl_cert = </var/lib/acme/dovecot_domains/fullchain.pem
        ssl_key = </var/lib/acme/dovecot_domains/key.pem
      }
      local_name dork.dev {
        ssl_cert = </var/lib/acme/dovecot_domains/fullchain.pem
        ssl_key = </var/lib/acme/dovecot_domains/key.pem
      }
      ssl_min_protocol = TLSv1.2
      ssl_cipher_list = EECDH+AESGCM:EDH+AESGCM
      ssl_prefer_server_ciphers = yes
      ssl_dh=<${config.security.dhparams.params.dovecot2.path}

      mail_plugins = virtual fts fts_lucene

      service lmtp {
        user = vmail
        unix_listener /var/lib/postfix/queue/private/dovecot-lmtp {
          group = postfix
          mode = 0600
          user = postfix
        }
      }

      service doveadm {
        inet_listener {
          port = 4170
          ssl = yes
        }
      }
      protocol lmtp {
        postmaster_address=postmaster@kittywit.ch
        hostname=${config.network.addresses.public.domain}
        mail_plugins = $mail_plugins sieve
      }
      service auth {
        unix_listener auth-userdb {
          mode = 0640
          user = vmail
          group = vmail
        }
        # Postfix smtp-auth
        unix_listener /var/lib/postfix/queue/private/auth {
          mode = 0666
          user = postfix
          group = postfix
        }
      }
      userdb {
        args = /run/dovecot2/ldap.conf
        driver = ldap
      }
      userdb {
        args = /run/dovecot2/ldap-services.conf
        driver = ldap
      }
      passdb {
        args = /run/dovecot2/ldap.conf
        driver = ldap
      }
      passdb {
        args = /run/dovecot2/ldap-services.conf
        driver = ldap
      }

      service imap-login {
        client_limit = 1000
        service_count = 0
        inet_listener imaps {
          port = 993
        }
      }

      service managesieve-login {
        inet_listener sieve {
          port = 4190
        }
      }
      protocol sieve {
        managesieve_logout_format = bytes ( in=%i : out=%o )
      }
      plugin {
        sieve_dir = /var/vmail/%d/%n/sieve/scripts/
        sieve = /var/vmail/%d/%n/sieve/active-script.sieve
        sieve_extensions = +vacation-seconds
        sieve_vacation_min_period = 1min

        fts = lucene
        fts_lucene = whitespace_chars=@.
      }

      # If you have Dovecot v2.2.8+ you may get a significant performance improvement with fetch-headers:
      imapc_features = $imapc_features fetch-headers
      # Read multiple mails in parallel, improves performance
      mail_prefetch_count = 20
    '';
    modules = [
      pkgs.dovecot_pigeonhole
    ];
    protocols = [
      "sieve"
    ];
  };

  users.users.vmail = {
    home = "/var/vmail";
    createHome = true;
    isSystemUser = true;
    uid = 1042;
    shell = "/run/current-system/sw/bin/nologin";
  };

  security.dhparams = {
    enable = true;
    params.dovecot2 = { };
  };

  kw.secrets.variables."dovecot-ldap-password" = {
    path = "services/dovecot";
    field = "password";
  };

  secrets.files.dovecot-ldap-password.text = ''
    ${tf.variables.dovecot-ldap-password.ref}
  '';

  systemd.services.dovecot2.preStart = ''
    sed -e "s!@ldap-password@!$(<${config.secrets.files.dovecot-ldap-password.path})!" ${ldapConfig} > /run/dovecot2/ldap.conf
    sed -e "s!@ldap-password@!$(<${config.secrets.files.dovecot-ldap-password.path})!" ${ldapConfig-services} > /run/dovecot2/ldap-services.conf
  '';

  networking.firewall.allowedTCPPorts = [
    143 # imap
    993 # imaps
    4190 # sieve
  ];
}
