{ pkgs, lib, config, tf, ... }:

let
  publicCert = "public_${config.networking.hostName}";

  ldaps = "ldaps://auth.${config.network.dns.domain}:636";

  virtualRegex = pkgs.writeText "virtual-regex" ''
    /^kat\.[^@.]+@kittywit\.ch$/ kat@kittywit.ch
    /^kat\.[^@.]+@dork\.dev$/ kat@kittywit.ch
  '';

  helo_access = pkgs.writeText "helo_access" ''
        ${config.network.addresses.public.nixos.ipv4.selfaddress}   REJECT Get lost - you're lying about who you are
        ${config.network.addresses.public.nixos.ipv6.selfaddress}   REJECT Get lost - you're lying about who you are
        kittywit.ch   REJECT Get lost - you're lying about who you are
        dork.dev   REJECT Get lost - you're lying about who you are
  '';
in {
  kw.secrets.variables."postfix-ldap-password" = {
    path = "services/dovecot";
    field = "password";
  };

  secrets.files = {
    domains-ldap = {
      text = ''
        server_host = ${ldaps}
        search_base = dc=domains,dc=mail,dc=kittywit,dc=ch
        query_filter = (&(dc=%s)(objectClass=mailDomain))
        result_attribute = postfixTransport
        bind = yes
        bind_dn = cn=dovecot,dc=mail,dc=kittywit,dc=ch
        bind_pw = ${tf.variables.postfix-ldap-password.ref}
        scope = one
      '';
      owner = "postfix";
      group = "postfix";
    };

    accountsmap-ldap = {
      text = ''
        server_host = ${ldaps}
        search_base = ou=users,dc=kittywit,dc=ch
        query_filter = (&(objectClass=mailAccount)(mail=%s))
        result_attribute = mail
        bind = yes
        bind_dn = cn=dovecot,dc=mail,dc=kittywit,dc=ch
        bind_pw = ${tf.variables.postfix-ldap-password.ref}
      '';
      owner = "postfix";
      group = "postfix";
    };

    aliases-ldap = {
      text = ''
        server_host = ${ldaps}
        search_base = dc=aliases,dc=mail,dc=kittywit,dc=ch
        query_filter = (&(objectClass=mailAlias)(mail=%s))
        result_attribute = maildrop
        bind = yes
        bind_dn = cn=dovecot,dc=mail,dc=kittywit,dc=ch
        bind_pw = ${tf.variables.postfix-ldap-password.ref}
      '';
      owner = "postfix";
      group = "postfix";
    };
  };

  services.postfix = {
    enable = true;
    enableSubmission = true;
    hostname = config.network.addresses.public.domain;
    domain = config.network.dns.domain;

    masterConfig."465" = {
      type = "inet";
      private = false;
      command = "smtpd";
      args = [
        "-o smtpd_client_restrictions=permit_sasl_authenticated,reject"
        "-o syslog_name=postfix/smtps"
        "-o smtpd_tls_wrappermode=yes"
        "-o smtpd_sasl_auth_enable=yes"
        "-o smtpd_tls_security_level=none"
        "-o smtpd_reject_unlisted_recipient=no"
        "-o smtpd_recipient_restrictions="
        "-o smtpd_relay_restrictions=permit_sasl_authenticated,reject"
        "-o milter_macro_daemon_name=ORIGINATING"
      ];
    };

    mapFiles."virtual-regex" = virtualRegex;
    mapFiles."helo_access" = helo_access;

    extraConfig = ''
      smtp_bind_address = ${if tf.state.enable then tf.resources.${config.networking.hostName}.getAttr "private_ip" else config.network.addresses.public.nixos.ipv4.selfaddress}
      smtp_bind_address6 = ${config.network.addresses.public.nixos.ipv6.selfaddress}
      mailbox_transport = lmtp:unix:private/dovecot-lmtp
      masquerade_domains = ldap:${config.secrets.files.domains-ldap.path}
      virtual_mailbox_domains = ldap:${config.secrets.files.domains-ldap.path}
      virtual_alias_maps = ldap:${config.secrets.files.accountsmap-ldap.path},ldap:${config.secrets.files.aliases-ldap.path},regexp:/var/lib/postfix/conf/virtual-regex
      virtual_transport = lmtp:unix:private/dovecot-lmtp
      smtpd_milters = unix:/run/opendkim/opendkim.sock,unix:/run/rspamd/rspamd-milter.sock
      non_smtpd_milters = unix:/run/opendkim/opendkim.sock
      milter_protocol = 6
      milter_default_action = accept
      milter_mail_macros = i {mail_addr} {client_addr} {client_name} {auth_type} {auth_authen} {auth_author} {mail_addr} {mail_host} {mail_mailer}

      # bigger attachement size
      mailbox_size_limit = 202400000
      message_size_limit = 51200000
      smtpd_helo_required = yes
      smtpd_delay_reject = yes
      strict_rfc821_envelopes = yes

      # send Limit
      smtpd_error_sleep_time = 1s
      smtpd_soft_error_limit = 10
      smtpd_hard_error_limit = 20

      smtpd_use_tls = yes
      smtp_tls_note_starttls_offer = yes
      smtpd_tls_security_level = may
      smtpd_tls_auth_only = yes

      smtpd_tls_cert_file = /var/lib/acme/${publicCert}/full.pem
      smtpd_tls_key_file = /var/lib/acme/${publicCert}/key.pem
      smtpd_tls_CAfile = /var/lib/acme/${publicCert}/fullchain.pem

      smtpd_tls_dh512_param_file = ${config.security.dhparams.params.postfix512.path}
      smtpd_tls_dh1024_param_file = ${config.security.dhparams.params.postfix2048.path}

      smtpd_tls_session_cache_database = btree:''${data_directory}/smtpd_scache
      smtpd_tls_mandatory_protocols = !SSLv2,!SSLv3,!TLSv1,!TLSv1.1
      smtpd_tls_protocols = !SSLv2,!SSLv3,!TLSv1,!TLSv1.1
      smtpd_tls_mandatory_ciphers = medium
      tls_medium_cipherlist = AES128+EECDH:AES128+EDH

      # authentication
      smtpd_sasl_auth_enable = yes
      smtpd_sasl_local_domain = $mydomain
      smtpd_sasl_security_options = noanonymous
      smtpd_sasl_tls_security_options = $smtpd_sasl_security_options
      smtpd_sasl_type = dovecot
      smtpd_sasl_path = /var/lib/postfix/queue/private/auth
      smtpd_relay_restrictions = permit_mynetworks,
                                 permit_sasl_authenticated,
                                 defer_unauth_destination
      smtpd_client_restrictions = permit_mynetworks,
                                permit_sasl_authenticated,
                                reject_invalid_hostname,
                                reject_unknown_client,
                                permit
      smtpd_helo_restrictions = permit_mynetworks,
                              permit_sasl_authenticated,
                              reject_unauth_pipelining,
                              reject_non_fqdn_hostname,
                              reject_invalid_hostname,
                              warn_if_reject reject_unknown_hostname,
                              permit
      smtpd_recipient_restrictions = permit_mynetworks,
                               permit_sasl_authenticated,
                               reject_non_fqdn_sender,
                               reject_non_fqdn_recipient,
                               reject_non_fqdn_hostname,
                               reject_invalid_hostname,
                               reject_unknown_sender_domain,
                               reject_unknown_recipient_domain,
                               reject_unknown_client_hostname,
                               reject_unauth_pipelining,
                               reject_unknown_client,
                               permit
      smtpd_sender_restrictions = permit_mynetworks,
                          permit_sasl_authenticated,
                          reject_non_fqdn_sender,
                          reject_unknown_sender_domain,
                          reject_unknown_client_hostname,
                          reject_unknown_address

      smtpd_etrn_restrictions = permit_mynetworks, reject
      smtpd_data_restrictions = reject_unauth_pipelining, reject_multi_recipient_bounce, permit
    '';
  };

  systemd.services.postfix.wants = [ "openldap.service" "acme-${publicCert}.service" ];
  systemd.services.postfix.after = [ "openldap.service" "acme-${publicCert}.service" "network.target" ];

  security.dhparams = {
    enable = true;
    params.postfix512.bits = 512;
    params.postfix2048.bits = 1024;
  };

  networking.firewall.allowedTCPPorts = [
    25 # smtp
    465 # stmps
    587 # submission
  ];
}
