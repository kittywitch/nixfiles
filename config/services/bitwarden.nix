{ config, pkgs, witch, ... }:

{
  services.bitwarden_rs = {
    enable = true;
    config = {
      rocketPort = 4000;
      websocketEnabled = true;
      signupsAllowed = false;
      adminToken = witch.secrets.hosts.athame.bitwarden_secret;
      domain = "https://vault.kittywit.ch";
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
}
