{ config, lib, pkgs, tf, ... }:

with lib;

{
  kw.secrets = [
    "syncplay-pass"
    "syncplay-salt"
  ];

  users.users.syncplay = { isSystemUser = true; };

  users.groups."sync-cert".members = [ "nginx" "syncplay" ];
  security.acme = {
    certs."sync.${config.kw.dns.domain}" = {
      group = "sync-cert";
      postRun = ''
        cp key.pem privkey.pem
        chown acme:voice-cert privkey.pem
      '';
    };
  };

  kw.fw.public.tcp.ports = singleton 8999;

  services.nginx.virtualHosts."sync.${config.kw.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
  };

  deploy.tf.dns.records.services_syncplay = {
    tld = config.kw.dns.tld;
    domain = "sync";
    cname.target = "${config.networking.hostName}.${config.kw.dns.tld}";
  };

  secrets.files.syncplay-env = {
    text = ''
      SYNCPLAY_PASSWORD=${tf.variables.syncplay-pass.ref}
      SYNCPLAY_SALT=${tf.variables.syncplay-salt.ref}
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
        "${pkgs.syncplay}/bin/syncplay-server --port 8999 --tls /var/lib/acme/sync.${config.kw.dns.domain}/ --disable-ready";
      User = "syncplay";
      Group = "sync-cert";
    };
  };
}
