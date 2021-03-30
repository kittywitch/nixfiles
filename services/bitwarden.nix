{ config, pkgs, witch, ... }:

{
  services.postgresql = {
    ensureDatabases = [ "bitwarden_rs" ];
    ensureUsers = [{
      name = "bitwarden_rs";
      ensurePermissions = { "DATABASE bitwarden_rs" = "ALL PRIVILEGES"; };
    }];
  };

  services.bitwarden_rs = {
    enable = true;
    dbBackend = "postgresql";
    config = {
      rocketPort = 4000;
      websocketEnabled = true;
      signupsAllowed = false;
      adminToken = witch.secrets.hosts.athame.bitwarden_secret;
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
