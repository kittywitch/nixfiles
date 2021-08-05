{ config, lib, pkgs, tf, ... }:

with lib;

{
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
        "${pkgs.syncplay}/bin/syncplay-server --port 8999 --tls /var/lib/acme/sync.${config.kw.dns.domain}/ --disable-ready";
      User = "syncplay";
      Group = "sync-cert";
    };
  };
}
