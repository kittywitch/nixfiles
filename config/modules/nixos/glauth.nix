{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.glauth;
  dbcfg = config.services.glauth.database;
in
{
  options.services.glauth = {
    enable = mkEnableOption "GLAuth";
    package = mkOption {
      type = types.package;
      default = pkgs.glauth;
    };
    outTOML = mkOption {
      description = "The TOML produced from cfg.settings";
      type = types.str;
      default = toTOML cfg.settings;
    };
    configFile = mkOption {
      description = "The config path that GLAuth uses";
      type = types.path;
      default = pkgs.writeText "glauth-config" cfg.outTOML;
    };
    database = {
      enable = mkEnableOption "use a database";
      local = mkEnableOption "local database creation" // { default = true; };
      type = mkOption {
        type = types.enum [
          "postgres"
          "mysql"
          "sqlite"
        ];
        default = "postgres";
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
      };
      port = mkOption {
        type = types.port;
        default = 5432;
      };
      username = mkOption {
        type = types.str;
        default = "glauth";
      };
      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
      };
      ssl = mkEnableOption "use ssl for the database connection";
    };
    settings = mkOption {
      type = json.types.attrs;
      default = mkIf cfg.database.enable {
        backend =
          let
            pluginHandlers = {
              "mysql" = "NewMySQLHandler";
              "postgres" = "NewPostgresHandler";
              "sqlite" = "NewSQLiteHandler";
            };
          in
          {
            datastore = "plugin";
            plugin = "bin/${cfg.database.type}.so";
            pluginhandler = pluginHandlers.${dbcfg.type};
            database = if (dbcfg.type != "sqlite") then (builtins.replaceStrings (singleton "\n") (singleton " ") ''
              host=${dbcfg.host}
              port=${dbcfg.port}
              dbname=glauth
              username=${dbcfg.username}
              password=@db-password@
              sslmode=${if dbcfg.ssl then "enable" else "disable"}
            '') else "database = \"gl.db\"";
          };
      };
    };
  };
  config =
    let
      localCheck = dbcfg.local && dbcfg.enable && dbcfg.host == "localhost";
      postgresCheck = localCheck && dbcfg.type == "postgres";
      mysqlCheck = localCheck && dbcfg.type == "mysql";
    in
    mkIf cfg.enable {
    systemd.services.glauthPostgreSQLInit = lib.mkIf postgresCheck {
      after = [ "postgresql.service" ];
      before = [ "glauth.service" ];
      bindsTo = [ "postgresql.service" ];
      path = [ config.services.postgresql.package ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "postgres";
        Group = "postgres";
      };
      script = ''
        set -o errexit -o pipefail -o nounset -o errtrace
        shopt -s inherit_errexit
        create_role="$(mktemp)"
        trap 'rm -f "$create_role"' ERR EXIT
        echo "CREATE ROLE glauth WITH LOGIN PASSWORD '$(<'${dbcfg.passwordFile}')' CREATEDB" > "$create_role"
        psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='glauth'" | grep -q 1 || psql -tA --file="$create_role"
        psql -tAc "SELECT 1 FROM pg_database WHERE datname = 'glauth'" | grep -q 1 || psql -tAc 'CREATE DATABASE "glauth" OWNER "glauth"'
      '';
    };

    systemd.services.glauthMySQLInit = lib.mkIf mysqlCheck {
      after = [ "mysql.service" ];
      before = [ "glauth.service" ];
      bindsTo = [ "mysql.service" ];
      path = [ config.services.mysql.package ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = config.services.mysql.user;
        Group = config.services.mysql.group;
      };
      script = ''
        set -o errexit -o pipefail -o nounset -o errtrace
        shopt -s inherit_errexit
        db_password="$(<'${dbcfg.passwordFile}')"
        ( echo "CREATE USER IF NOT EXISTS 'glauth'@'localhost' IDENTIFIED BY '$db_password';"
          echo "CREATE DATABASE glauth CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
          echo "GRANT ALL PRIVILEGES ON glauth.* TO 'glauth'@'localhost';"
        ) | mysql -N
      '';
    };

    users.groups.glauth = { };
    users.users.glauth = {
      isSystemUser = true;
      extraGroups = singleton "glauth";
    };

    systemd.services.glauth =
      let
        databaseServices = attrByPath [ dbcfg.type ] [ ] {
          "mysql" = [ "glauthMySQLInit.service" "mysql.service" ];
          "postgres" = [ "glauthPostgreSQLInit.service" "postgresql.service" ];
        };
      in {
        after = databaseServices;
        bindsTo = databaseServices;
        wantedBy = singleton "multi-user.target";
        path = with pkgs; [
          cfg.package
          replace-secret
        ];
      serviceConfig = {
        ExecStartPre =
          let
            startPreFullPrivileges = ''
              set -o errexit -o pipefail -o nounset -o errtrace
              shopt -s inherit_errexit
              umask u=rwx,g=,o=
              mkdir -p /run/glauth/secrets
              chown -R glauth:glauth /run/glauth/
              install -T -m 0400 -o glauth -g glauth '${dbcfg.passwordFile}' /run/glauth/secrets/db_password
            '';
            startPre = ''
              install -T -m 0600 ${cfg.configFile} /run/glauth/config.cfg
              replace-secret '@db-password@' '/run/glauth/secrets/db_password' /run/glauth/config.cfg
            '';
          in
          [
            "+${pkgs.writeShellScript "glauth-start-pre-full-privileges" startPreFullPrivileges}"
            "${pkgs.writeShellScript "glauth-start-pre" startPre}"
          ];
        ExecStart = "${cfg.package}/bin/glauth -c /run/glauth/config.cfg";
        User = "glauth";
        Group = "glauth";
        RuntimeDirectory = "glauth";
        LogsDirectory = "glauth";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      };
    };
  };

  meta.maintainers = with maintainers; [ kittywitch ];
}
