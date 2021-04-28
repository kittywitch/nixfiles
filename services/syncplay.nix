{ config, lib, pkgs, tf, ... }:

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

  deploy.tf.variables.syncplay_pass = {
    type = "string";
    value.shellCommand = "bitw get infra/syncplay-server -f password";
  };

  deploy.tf.variables.syncplay_salt = {
    type = "string";
    value.shellCommand = "bitw get infra/syncplay-salt -f password";
  };

  secrets.files.syncplay-env = {
    text = ''
      SYNCPLAY_PASSWORD=${tf.variables.syncplay_pass.ref}
      SYNCPLAY_SALT=${tf.variables.syncplay_salt.ref}
    '';
    owner = "syncplay";
    group = "sync-cert";
  };

  systemd.services.syncplay = {
    description = "Syncplay Service";
    wantedBy = singleton "multi-user.target";
    after = singleton "network-online.target";

    serviceConfig = {
      EnvironmentFile = config.secrets.files.syncplay-env.path;
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
