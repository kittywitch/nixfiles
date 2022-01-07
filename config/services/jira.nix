{ config, pkgs, lib, tf, ... }: with lib; {
  services.jira = {
    enable = true;
  };


  deploy.tf.dns.records.services_jira = {
    inherit (config.network.dns) zone;
    domain = "jira";
    cname = { inherit (config.network.addresses.public) target; };
  };

  systemd.services.jiraPostgresSQLInit = {
    after = [ "postgresql.service" ];
    before = [ "jira.service" ];
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
      echo "CREATE ROLE jira WITH LOGIN PASSWORD '$(<'${config.secrets.files.jira-postgres-file.path}')' CREATEDB" > "$create_role"
      psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='jira'" | grep -q 1 || psql -tA --file="$create_role"
      psql -tAc "SELECT 1 FROM pg_database WHERE datname = 'jira'" | grep -q 1 || psql -tAc 'CREATE DATABASE "jira" OWNER "jira"'
    '';
  };


  kw.secrets.variables.jira-postgres = {
    path = "secrets/jira";
    field = "password";
  };

  secrets.files.jira-postgres-file = {
    text = "${tf.variables.jira-postgres.ref}";
    owner = "postgres";
    group = "jira";
  };

  users.users.nginx.extraGroups = [ "jira" ];
  services.nginx.virtualHosts."jira.${config.network.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8091";
      proxyWebsockets = true;
    };
  };
}
