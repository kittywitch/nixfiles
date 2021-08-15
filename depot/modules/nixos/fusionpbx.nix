{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.fusionpbx;
  toKeyValue = generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault {} " = ";
  };
  php = "${pkgs.php74}/bin/php";
  psql_base = "${pkgs.postgresql_11}/bin/psql";
  psql = if ! cfg.useLocalPostgreSQL then
    "${psql_base} --host=${cfg.postgres.host} --port=${cfg.postgres.port} --username=${cfg.postgres.db_username}"
    else psql_base;
  freeSwitchConfig = pkgs.writeShellScriptBin "copy_config" ''
      set -exu
      if [ ! -f "${cfg.home}/state/installed" ]; then
        mkdir -p /etc/freeswitch
        cp --no-preserve=mode,ownership -r ${cfg.package}/resources/templates/conf/* /etc/freeswitch
      fi
  '';
  installerReplacement = pkgs.writeShellScriptBin "installer_replacement" ''
    set -exu

    if [ -f "${cfg.home}/state/installed" ]; then
      if [ -f "${cfg.home}/state/lastversion" ]; then
        lastversion=$(<${cfg.home}/state/lastversion)
        if [ lastversion != "${cfg.package.version}" ]; then
          ${php} ${cfg.package}/core/upgrade/upgrade_schema.php
          echo "${cfg.package.version}" >| ${cfg.home}/state/lastversion
        fi
      fi
    else
      mkdir -p /var/lib/fusionpbx

      ${if ! cfg.useLocalPostgreSQL then "PGPASSWORD=${cfg.postgres.db_password}" else ""}
      ${php} ${cfg.package}/core/upgrade/upgrade_schema.php

      domain_uuid=$(${php} ${cfg.package}/resources/uuid.php);
      domain_name=${cfg.domain}
      ${psql}  -c "insert into v_domains (domain_uuid, domain_name, domain_enabled) values('$domain_uuid', '$domain_name', 'true');"
      cd "${cfg.package}" && ${php} ${cfg.package}/core/upgrade/upgrade_domains.php

      user_uuid=$(${php} ${cfg.package}/resources/uuid.php);
      user_salt=$(${php} ${cfg.package}/resources/uuid.php);

      password_hash=$(${php} -r "echo md5('$user_salt$USER_PASSWORD');");
      ${psql} -t -c "insert into v_users (user_uuid, domain_uuid, username, password, salt, user_enabled) values('$user_uuid', '$domain_uuid', '$USER_NAME', '$password_hash', '$user_salt', 'true');"

      group_uuid=$(${psql} -qtAX -c "select group_uuid from v_groups where group_name = 'superadmin';");
    group_uuid=$(echo $group_uuid | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//')
user_group_uuid=$(${php} ${cfg.package}/resources/uuid.php);
      group_name=superadmin
          #echo "insert into v_user_groups (user_group_uuid, domain_uuid, group_name, group_uuid, user_uuid) values('$user_group_uuid', '$domain_uuid', '$group_name', '$group_uuid', '$user_uuid');"
         ${psql} -c "insert into v_user_groups (user_group_uuid, domain_uuid, group_name, group_uuid, user_uuid) values('$user_group_uuid', '$domain_uuid', '$group_name', '$group_uuid', '$user_uuid');"

      xml_cdr_username=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')
      xml_cdr_password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64 | sed 's/[=\+//]//g')
      sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_http_protocol}:http:"
      sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_project_path}::"
      sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_user}:$xml_cdr_username:"
      sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_pass}:$xml_cdr_password:"

      cd "${cfg.package}" && ${php} ${cfg.package}/core/upgrade/upgrade_domains.php

      mkdir -p ${cfg.home}/state
      touch ${cfg.home}/state/installed
    fi
  '';
in {
  options.services.fusionpbx = {
    enable = mkEnableOption "Enable FusionPBX";
    openFirewall = mkEnableOption "Open the firewall for FusionPBX" // { default = true; };
    useLocalPostgreSQL = mkEnableOption "Use Local PostgreSQL for FusionPBX" // { default = true; };
    postgres = {
      host = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      port = mkOption {
        type = types.nullOr types.port;
        default = null;
      };
      db_name = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      db_username = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      db_password = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };

    environmentFile = mkOption {
      type = types.str;
      example = ''
        USER_NAME="meow"
        USER_PASSWORD="nya"
      '';
    };

    hardphones = mkEnableOption "Are you going to use hardphones with FusionPBX?";
    useWebrootACME = mkEnableOption "Do you want webroot-style ACME cert generation?";
    useACMEHost = mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    domain = mkOption {
      type = types.str;
    };

    package = mkOption {
      type = types.package;
      description = "What package to use for FusionPBX?";
      default = pkgs.fusionpbx;
      relatedPackages = [
        "fusionpbx"
      ];
    };

    freeSwitchPackage = mkOption {
      type = types.package;
      description = "What package to use for FreeSWITCH?";
      default = pkgs.freeswitch;
      relatedPackages = [
        "freeswitch"
      ];
    };

    home = mkOption {
      type = types.str;
      default = "/var/lib/fusionpbx";
      description = "Storage path for FusionPBX";
    };
  };

  config = mkIf cfg.enable {
    # User & Group Definition
    users.users.fusionpbx = {
      home = cfg.home;
      group = "fusionpbx";
      createHome = true;
      isSystemUser = true;
    };
    users.groups.fusionpbx.members = [
      "fusionpbx"
      config.services.nginx.user
    ];

    # PostgreSQL
    services.postgresql = mkIf cfg.useLocalPostgreSQL {
      ensureUsers = [
        {
          name = "fusionpbx";
          ensurePermissions = {
            "DATABASE fusionpbx" = "ALL PRIVILEGES";
            "DATABASE freeswitch" = "ALL PRIVILEGES";
          };
        }
      ];
      ensureDatabases = [ "fusionpbx" "freeswitch" ];
    };

    # ACME
    security.acme.certs = mkMerge [
      (mkIf cfg.useWebrootACME {
        ${cfg.domain} = {
          group = "fusionpbx";
        };
      })
      (mkIf (cfg.useACMEHost != null) {
        ${cfg.useACMEHost} = {
          postRun = ''
            cat {cert,key,chain}.pem >> all.pem
            ln -s all.pem agent.pem
            ln -s all.pem dlts-srtp.pem
            ln -s all.pem tls.pem
            ln -s all.pem wss.pem
          '';
        };
      })
    ];

    # NGINX
    services.nginx = {
      enable = mkDefault true;
      virtualHosts.${cfg.domain} = {
        enableACME = cfg.useWebrootACME;
        useACMEHost = cfg.useACMEHost;
        forceSSL = true;
        # forceSSL = true; # This might not make sense due to SSL-incapable hardphones?
        root = cfg.package;
        locations = {
          "/" = {
            index = "index.php";
          };
          "~ .htaccess".extraConfig = "deny all;";
          "~ .htpassword".extraConfig = "deny all;";
          "~^.+.(db)$".extraConfig = "deny all;";
          "~ \\.php$" = {
            extraConfig = ''
              include ${pkgs.nginx}/conf/fastcgi_params;
              fastcgi_pass    unix:${config.services.phpfpm.pools.fusionpbx.socket};
              fastcgi_index   index.php;
              fastcgi_param   SCRIPT_FILENAME ${cfg.package}$fastcgi_script_name;
            '';
          };
          " = /core/upgrade/index.php".extraConfig = ''
              include ${pkgs.nginx}/conf/fastcgi_params;
              fastcgi_pass    unix:${config.services.phpfpm.pools.fusionpbx.socket};
              fastcgi_index   index.php;
              fastcgi_param   SCRIPT_FILENAME ${cfg.package}$fastcgi_script_name;
              fastcgi_read_timeout 15m;
          '';
        };
        /*
          if ($uri !~* ^.*(provision|xml_cdr).*$) {
                rewrite ^(.*) https://$host$1 permanent;
                break;
          }
        */
        extraConfig = ''
          client_max_body_size 80M;
          client_body_buffer_size 128k;


          #REST api
          if ($uri ~* ^.*/api/.*$) {
                rewrite ^(.*)/api/(.*)$ $1/api/index.php?rewrite_uri=$2 last;
                break;
          }
        '' + optionalString cfg.hardphones ''
         #algo
          rewrite "^.*/provision/algom([A-Fa-f0-9]{12})(\.(conf))?$" /app/provision/?mac=$1;

          #mitel
          rewrite "^.*/provision/MN_([A-Fa-f0-9]{12})\.cfg" /app/provision/index.php?mac=$1&file=MN_%7b%24mac%7d.cfg last;
          rewrite "^.*/provision/MN_Generic.cfg" /app/provision/index.php?mac=08000f000000&file=MN_Generic.cfg last;

          #grandstream
          rewrite "^.*/provision/cfg([A-Fa-f0-9]{12})(\.(xml|cfg))?$" /app/provision/?mac=$1;
          rewrite "^.*/provision/pb([A-Fa-f0-9-]{12,17})/phonebook\.xml$" /app/provision/?mac=$1&file=phonebook.xml;
          #grandstream-wave softphone by ext because Android doesn't pass MAC.
          rewrite "^.*/provision/([0-9]{5})/cfg([A-Fa-f0-9]{12}).xml$" /app/provision/?ext=$1;

          #aastra
          rewrite "^.*/provision/aastra.cfg$" /app/provision/?mac=$1&file=aastra.cfg;
        #rewrite "^.*/provision/([A-Fa-f0-9]{12})(\.(cfg))?$" /app/provision/?mac=$1 last;

          #yealink common
          rewrite "^.*/provision/(y[0-9]{12})(\.cfg)?$" /app/provision/index.php?file=$1.cfg;

          #yealink mac
          rewrite "^.*/provision/([A-Fa-f0-9]{12})(\.(xml|cfg))?$" /app/provision/index.php?mac=$1 last;

          #polycom
          rewrite "^.*/provision/000000000000.cfg$" "/app/provision/?mac=$1&file={%24mac}.cfg";
        #rewrite "^.*/provision/sip_330(\.(ld))$" /includes/firmware/sip_330.$2;
          rewrite "^.*/provision/features.cfg$" /app/provision/?mac=$1&file=features.cfg;
          rewrite "^.*/provision/([A-Fa-f0-9]{12})-sip.cfg$" /app/provision/?mac=$1&file=sip.cfg;
          rewrite "^.*/provision/([A-Fa-f0-9]{12})-phone.cfg$" /app/provision/?mac=$1;
          rewrite "^.*/provision/([A-Fa-f0-9]{12})-registration.cfg$" "/app/provision/?mac=$1&file={%24mac}-registration.cfg";
          rewrite "^.*/provision/([A-Fa-f0-9]{12})-directory.xml$" "/app/provision/?mac=$1&file={%24mac}-directory.xml";

          #cisco
          rewrite "^.*/provision/file/(.*\.(xml|cfg))" /app/provision/?file=$1 last;

          #Escene
          rewrite "^.*/provision/([0-9]{1,11})_Extern.xml$"       "/app/provision/?ext=$1&file={%24mac}_extern.xml" last;
          rewrite "^.*/provision/([0-9]{1,11})_Phonebook.xml$"    "/app/provision/?ext=$1&file={%24mac}_phonebook.xml" last;

          #Vtech
          rewrite "^.*/provision/VCS754_([A-Fa-f0-9]{12})\.cfg$" /app/provision/?mac=$1;
          rewrite "^.*/provision/pb([A-Fa-f0-9-]{12,17})/directory\.xml$" /app/provision/?mac=$1&file=directory.xml;

          #Digium
          rewrite "^.*/provision/([A-Fa-f0-9]{12})-contacts\.cfg$" "/app/provision/?mac=$1&file={%24mac}-contacts.cfg";
          rewrite "^.*/provision/([A-Fa-f0-9]{12})-smartblf\.cfg$" "/app/provision/?mac=$1&file={%24mac}-smartblf.cfg";
        '';
      };
    };

    # PHP 7.4
    services.phpfpm = {
      pools.fusionpbx = {
        user = "fusionpbx";
        group = "fusionpbx";
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
          "listen.owner" = "fusionpbx";
          "listen.group" = config.services.nginx.group;
        };
        phpPackage = pkgs.php74.buildEnv {
          extensions = { enabled, all }: (
            with all;
            enabled ++ [
              imap
              pgsql
              curl
              opcache
              pdo
              pdo_pgsql
              soap
              xmlrpc
              gd
            ]
          );
          extraConfig = toKeyValue {
          };
        };
      };
    };

    # FreeSWITCH
    systemd.tmpfiles.rules = [
      "v /etc/freeswitch 5777 fusionpbx fusionpbx"
      "v /etc/fusionpbx 5777 fusionpbx fusionpbx"
      "v /var/cache/fusionpbx 5777 fusionpbx fusionpbx"
    ];

    systemd.services.freeswitch = let
      pkg = cfg.freeSwitchPackage;
      configPath = "/etc/freeswitch";
    in {
      description = "Free and open-source application server for real-time communication";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "fusionpbx";
        Group = "fusionpbx";
        StateDirectory = "freeswitch";
        ExecStartPre = "${freeSwitchConfig}/bin/copy_config";
        ExecStart = "${pkg}/bin/freeswitch -nf \\
          -mod ${pkg}/lib/freeswitch/mod \\
          -conf ${configPath} \\
          -base /var/lib/freeswitch";
        ExecReload = "${pkg}/bin/fs_cli -x reloadxml";
        Restart = "on-failure";
        RestartSec = "5s";
        CPUSchedulingPolicy = "fifo";
      };
    };

    systemd.services.fusionpbx = {
      after = [ "network.target" ];
      wantedBy = [ "freeswitch.service" ];
      script = "${installerReplacement}/bin/installer_replacement";
      serviceConfig = {
        EnvironmentFile = cfg.environmentFile;
        User = "fusionpbx";
        Group = "fusionpbx";
        Type = "oneshot";
        StateDirectory = "fusionpbx";
      };
    };

    # FusionPBX Config
    environment.etc."fusionpbx/config.php" = {
      user = "nginx";
      group = "fusionpbx";
      text = let
        hostConfig = if cfg.useLocalPostgreSQL then ''
          $db_type = 'pgsql';
          $db_host = ''';
          $db_port = ''';
          $db_name = 'fusionpbx';
          $db_username = 'fusionpbx';
          $db_password = ''';
      '' else ''
        $db_type = 'pgsql';
        $db_host = '${cfg.postgres.host}';
        $db_port = '${toString cfg.postgres.port}';
        $db_name = '${cfg.postgres.db_name}';
        $db_username = '${cfg.postgres.db_username}';
        $db_password = '${cfg.postgres.db_password}';
      ''; in ''
          <?php
          ${hostConfig}
          ini_set('display_errors', '1');
          error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);
          ?>
      '';
    };

    # Firewall
    network.firewall = mkIf cfg.openFirewall {
      public = {
        tcp = {
          ports = [ 5060 5061 ];
          ranges = [
            {
              from = 10000;
              to = 20000;
            }
          ];
        };
        udp = {
          ports = [ 5060 5061 ];
          ranges = [
            {
              from = 10000;
              to = 20000;
            }
          ];
        };
      };
    };
  };
}
