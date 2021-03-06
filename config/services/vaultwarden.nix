{ config, pkgs, ... }:

{
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
      domain = "https://vault.kittywit.ch";
      databaseUrl = "postgresql://bitwarden_rs@/bitwarden_rs";
    };
  };

  services.nginx.virtualHosts."vault.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/".proxyPass = "http://127.0.0.1:4000";
      "/notifications/hub".proxyPass = "http://127.0.0.1:3012";
      "/notifications/hub/negotiate".proxyPass = "http://127.0.0.1:80";
    };
  };

  deploy.tf.dns.records.kittywitch_vault = {
    tld = "kittywit.ch.";
    domain = "vault";
    cname.target = "athame.kittywit.ch.";
  };
}
