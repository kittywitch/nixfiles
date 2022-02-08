{ config, tf, lib, ... }: with lib; {
  kw.secrets.variables.sogo-ldap = {
    path = "secrets/sogo";
    field = "password";
  };

  secrets.files.sogo-ldap = {
    text = ''
      ${tf.variables.sogo-ldap.ref}
    '';
    owner = "sogo";
    group = "sogo";
  };

  services.nginx.virtualHosts."mail.${config.network.dns.domain}" = {
    useACMEHost = "dovecot_domains";
    enableACME = mkForce false;
    forceSSL = true;
  };

  users.users.nginx.extraGroups = singleton "postfix";

  deploy.tf.dns.records.services_sogo = {
    inherit (config.network.dns) zone;
    domain = "mail";
    cname = { inherit (config.network.addresses.public) target; };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "sogo" ];
    ensureUsers = [{
      name = "sogo";
      ensurePermissions."DATABASE sogo" = "ALL PRIVILEGES";
    }];
  };

  services.memcached = {
    enable = true;
  };

  services.sogo = {
    enable = true;
    timezone = "Europe/London";
    vhostName = "mail.${config.network.dns.domain}";
    extraConfig = ''
      SOGoMailDomain = "kittywit.ch";
      SOGoPageTitle = "kittywitch";
      SOGoProfileURL =
          "postgresql://sogo@/sogo/sogo_user_profile";
      OCSFolderInfoURL =
          "postgresql://sogo@/sogo/sogo_folder_info";
      OCSSessionsFolderURL =
          "postgresql://sogo@/sogo/sogo_sessions_folder";
      SOGoMailingMechanism = "smtp";
      SOGoForceExternalLoginWithEmail = YES;
      SOGoSMTPAuthenticationType = PLAIN;
      SOGoSMTPServer = "smtps://${config.network.addresses.public.domain}:465";
      SOGoIMAPServer = "imaps://${config.network.addresses.public.domain}:993";
      SOGoUserSources = (
          {
              type = ldap;
              CNFieldName = cn;
              IDFieldName = uid;
              UIDFieldName = uid;
              baseDN = "ou=users,dc=kittywit,dc=ch";
              bindDN = "cn=sogo,ou=services,dc=kittywit,dc=ch";
              bindFields = (uid,mail);
              bindPassword = "LDAP_BINDPW";
              canAuthenticate = YES;
              displayName = "kittywitch Org";
              hostname = "ldaps://auth.kittywit.ch:636";
              id = public;
              isAddressBook = YES;
          }
      );
    '';
    configReplaces = {
      LDAP_BINDPW = config.secrets.files.sogo-ldap.path;
    };
  };
}
