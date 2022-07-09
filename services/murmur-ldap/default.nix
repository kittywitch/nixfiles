{ config, lib, tf, pkgs, ... }: with lib; let
  murmurLdapScript = ./LDAPauth.py;
in {
  kw.secrets.variables = {
    murmur-ldap-pass = {
      path = "social/mumble";
      field = "ldap";
    };
    murmur-ice = {
      path = "social/mumble";
      field = "ice";
    };
  };

  systemd.tmpfiles.rules = [
    "v /etc/murmur 0770 murmur murmur"
  ];

  secrets.files.murmur-ldap-ini = {
    text = ''
[user]
id_offset       = 1000000000
reject_on_error = True
reject_on_miss  = False

[ice]
host            = 127.0.0.1
port            = 6502
slice           = /etc/murmur/Murmur.ice
secret          =${tf.variables.murmur-ice.ref}
watchdog        = 30

[ldap]
bind_dn = cn=murmur,ou=services,dc=kittywit,dc=ch
bind_pass = ${tf.variables.murmur-ldap-pass.ref}
ldap_uri = ldaps://auth.kittywit.ch:636
users_dn = ou=users,dc=kittywit,dc=ch
discover_dn = false
username_attr = uid
number_attr = uidNumber
display_attr = cn
provide_info = True
mail_attr = mail
provide_users = True

[murmur]
servers      =

[log]
level   =
file    =

[iceraw]
Ice.ThreadPool.Server.Size = 5
    '';
    owner = "murmur";
    group = "murmur";
  };

  environment.etc."murmur/LDAPauth.ini".source = config.secrets.files.murmur-ldap-ini.path;

  systemd.services.murmur-ldap = let
    pythonEnv = pkgs.python39.withPackages(ps: with ps; [
      ldap
      zeroc-ice
      python-daemon
    ]);
  in {
    after = [ "network.target" "murmur.service" ];
    path = with pkgs; [
      zeroc-ice
    ];
    serviceConfig = {
      User = "murmur";
      Group = "murmur";
      ExecStart = "${pythonEnv}/bin/python3 ${murmurLdapScript}";
      WorkingDirectory = "/etc/murmur/";
    };
  };
}
