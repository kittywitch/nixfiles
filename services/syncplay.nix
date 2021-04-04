{ config, pkgs, ... }:

{
  users.users.syncplay = { isSystemUser = true; };

  users.groups."sync-cert".members = [ "nginx" "syncplay" ];
  security.acme = { certs."sync.kittywit.ch" = { group = "sync-cert"; }; };

  services.nginx.virtualHosts."sync.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
  };

  deploy.tf.dns.records.kittywitch_sync = {
    tld = "kittywit.ch.";
    domain = "sync";
    cname.target = "athame.kittywit.ch.";
  };

  services.syncplay = {
    enable = true;
    user = "syncplay";
    group = "sync-cert";
    certDir = "/var/lib/acme/sync.kittywit.ch/";
  };

  security.acme.certs."sync.kittywit.ch".postRun = ''
    cp key.pem privkey.pem
    chown acme:voice-cert privkey.pem'';
}
