{ config, lib, tf, ... }: with lib; {
  services.keycloak = {
    enable = true;
    bindAddress = "127.0.0.1";
    httpPort = "8089";
    httpsPort = "8445";
    initialAdminPassword = "mewpymewlymewlies";
    forceBackendUrlToFrontendUrl = true;
    frontendUrl = "https://auth.${config.network.dns.domain}/auth";
    database.passwordFile = config.secrets.files.keycloak-postgres-file.path;
  };

  users.groups.keycloak = { };
  users.users.postgres.extraGroups = singleton "keycloak";
  users.users.keycloak = {
    isSystemUser = true;
    extraGroups = singleton "keycloak";
  };

  kw.secrets.variables.keycloak-postgres = {
    path = "services/keycloak";
    field = "postgres";
  };

  secrets.files.keycloak-postgres-file = {
    text = "${tf.variables.keycloak-postgres.ref}";
    owner = "postgres";
    group = "keycloak";
  };

  services.nginx.virtualHosts."auth.${config.network.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:8089"; };
  };

  deploy.tf.dns.records.services_keycloak = {
    inherit (config.network.dns) zone;
    domain = "auth";
    cname = { inherit (config.network.addresses.public) target; };
  };
}
