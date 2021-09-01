{ config, pkgs, lib, tf, ... }:

{
  kw.secrets.variables = {
    vaultwarden-admin-token = {
      path = "secrets/vaultwarden";
    };
  };

  secrets.files.vaultwarden-env = {
    text = ''
      ADMIN_TOKEN=${tf.variables.vaultwarden-admin-token.ref}
    '';
    owner = "bitwarden_rs";
    group = "bitwarden_rs";
  };

  services.vaultwarden = {
    environmentFile = config.secrets.files.vaultwarden-env.path;
  };

  services.postgresql = {
    ensureDatabases = [ "bitwarden_rs" ];
    ensureUsers = [{
      name = "bitwarden_rs";
      ensurePermissions = { "DATABASE bitwarden_rs" = "ALL PRIVILEGES"; };
    }];
  };

  users.users.vaultwarden.name = "bitwarden_rs";
  users.groups.vaultwarden.name = "bitwarden_rs";

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    config = {
      rocketPort = 4000;
      websocketEnabled = true;
      signupsAllowed = false;
      domain = "https://vault.${config.network.dns.domain}";
      databaseUrl = "postgresql://bitwarden_rs@/bitwarden_rs";
    };
  };

  services.nginx.virtualHosts."vault.${config.network.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/".proxyPass = "http://127.0.0.1:4000";
      "/notifications/hub".proxyPass = "http://127.0.0.1:3012";
      "/notifications/hub/negotiate".proxyPass = "http://127.0.0.1:80";
    };
  };

  deploy.tf.dns.records.services_vaultwarden = {
    inherit (config.network.dns) zone;
    domain = "vault";
    cname = { inherit (config.network.addresses.public) target; };
  };
}
