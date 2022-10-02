{ config, lib, pkgs, tf, ... }: with lib; let
  toKeyValue = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault {} " = ";
  };
  installerReplacement = pkgs.writeShellScriptBin "installer_replacement" ''
       set -exu
        if [[ ! -f "/var/lib/xbackbone/state/installed" ]]; then
          mkdir -p /var/lib/xbackbone/files
          mkdir -p /var/lib/xbackbone/www
          mkdir -p /var/lib/xbackbone/state
          cp -Lr ${pkgs.xbackbone}/* /var/lib/xbackbone/www
          cp ${config.secrets.files.xbackbone-config.path} /var/lib/xbackbone/www/config.php
          chmod -R 0770 /var/lib/xbackbone/www
          chown -R xbackbone:nginx /var/lib/xbackbone/www
          touch /var/lib/xbackbone/state/installed
        fi
  '';
in {
  secrets.variables.xbackbone-ldap = {
    path = "secrets/xbackbone";
    field = "password";
  };

  secrets.files.xbackbone-config = {
    text = ''
<?php
return [
	'base_url' => 'https://files.kittywit.ch', // no trailing slash
	'storage' => [
		'driver' => 'local',
		'path' => '/var/lib/xbackbone/files',
	],
	'db' => [
		'connection' => 'sqlite', // current support for sqlite and mysql
		'dsn' => '/var/lib/xbackbone/xbackbone.db', // if sqlite should be an absolute path
		'username' => null, // username and password not needed for sqlite
		'password' => null,
        ],
        'ldap' => [
            'enabled' => true, // enable it
            'schema' => 'ldaps', // use 'ldap' or 'ldaps' Default is 'ldap'
            'host' => 'auth.kittywit.ch', // set the ldap host
            'port' => 636, // ldap port
            'base_domain' => 'ou=users,dc=kittywit,dc=ch', // the base_dn string
            'search_filter' => '(&(|(uid=????)(mail=????))(objectClass=inetOrgPerson))', // ???? is replaced with user provided username
            'rdn_attribute' => 'uid=', // the attribute to use as username
            'service_account_dn' => 'cn=xbackbone,ou=services,dc=kittywit,dc=ch', // LDAP Service Account Full DN
            'service_account_password' => "${tf.variables.xbackbone-ldap.ref}",
        ]
];
  '';
    owner = "xbackbone";
    group = "xbackbone";
    mode = "0440";
  };

  systemd.tmpfiles.rules = [
    "v /var/lib/xbackbone 0770 xbackbone nginx"
    "v /var/lib/xbackbone/files 0770 xbackbone nginx"
  ];

  users.users.xbackbone = {
    isSystemUser = true;
    group = "xbackbone";
    home = "/var/lib/xbackbone";
  };

  users.groups.xbackbone.members = [
    "xbackbone"
    config.services.nginx.user
  ];

  systemd.services.xbackbone = {
    after = [ "network.target" ];
    wantedBy = [ "phpfpm-xbackbone.service" ];
    script = "${installerReplacement}/bin/installer_replacement";
    serviceConfig = {
      User = "xbackbone";
      Group = "nginx";
      Type = "oneshot";
      StateDirectory = "xbackbone";
    };
  };

  services.nginx.virtualHosts = {
    "files.kittywit.ch" = {
      root = "/var/lib/xbackbone/www";
      locations = {
        "/" = {
          extraConfig = ''
            try_files $uri $uri/ /index.php?$query_string;
          '';
        };
          "~ \\.php$" = {
            extraConfig = ''
              include ${pkgs.nginx}/conf/fastcgi_params;
              fastcgi_pass    unix:${config.services.phpfpm.pools.xbackbone.socket};
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_index   index.php;
              fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
              fastcgi_param SCRIPT_NAME $fastcgi_script_name;
            '';
          };
        };
        extraConfig = ''
client_max_body_size 512M;
index index.php index.html index.htm;
error_page 404 /index.php;

location /app {
  return 403;
}

location /bin {
  return 403;
}

location /bootstrap {
  return 403;
}

location /resources {
  return 403;
}

location /storage {
  return 403;
}

location /vendor {
  return 403;
}

location /logs {
  return 403;
}

location CHANGELOG.md {
  return 403;
}
        '';
    };
  };

  services.phpfpm = {
    pools.xbackbone = {
      user = "xbackbone";
      group = "nginx";
      phpEnv = {
        PATH = "/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin:/bin";
      };
      settings = {
        "pm" = "dynamic";
        "pm.max_children" = "32";
        "pm.start_servers" = "2";
        "pm.min_spare_servers" = "2";
        "pm.max_spare_servers" = "4";
        "pm.max_requests" = "500";
        "listen.owner" = "xbackbone";
        "listen.group" = "xbackbone";
      };
      phpPackage = pkgs.php80.buildEnv {
        extraConfig = toKeyValue {
          upload_max_filesize = "512M";
          post_max_size = "512M";
          memory_limit = "512M";
        };
        extensions = { enabled, all }: (
          with all;
          enabled ++ [
            sqlite3
            intl
            zip
            ldap
            gd
          ]
        );
      };
    };
  };

  domains.kittywitch-filehost = {
    network = "internet";
    domain = "files";
    type = "cname";
  };
}
