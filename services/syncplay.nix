{ config, lib, pkgs, witch, ... }:

with lib;

{
  users.users.syncplay = { isSystemUser = true; };

  users.groups."sync-cert".members = [ "nginx" "syncplay" ];
  security.acme = { certs."sync.kittywit.ch" = { group = "sync-cert"; }; };

  katnet.public.tcp.ports = singleton 8999;

  services.nginx.virtualHosts."sync.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
  };

  deploy.tf.dns.records.kittywitch_sync = {
    tld = "kittywit.ch.";
    domain = "sync";
    cname.target = "athame.kittywit.ch.";
  };

  systemd.services.syncplay = {
    environment = {
      SYNCPLAY_PASSWORD = witch.secrets.hosts.athame.syncplay.password;
      SYNCPLAY_SALT = witch.secrets.hosts.athame.syncplay.salt;
    };
    description = "Syncplay Service";
    wantedBy = singleton "multi-user.target";
    after = singleton "network-online.target";

    serviceConfig = {
      ExecStart =
        "${pkgs.syncplay}/bin/syncplay-server --port 8999 --tls /var/lib/acme/sync.kittywit.ch/ --disable-ready";
      User = "syncplay";
      Group = "sync-cert";
    };
  };

  security.acme.certs."sync.kittywit.ch".postRun = ''
    cp key.pem privkey.pem
    chown acme:voice-cert privkey.pem'';
}
