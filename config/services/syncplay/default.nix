{ config, lib, pkgs, tf, ... }:

with lib;

{

  kw.secrets.variables = let
    fieldAdapt = field: if field == "pass" then "password" else field;
  in mapListToAttrs (field:
    nameValuePair "syncplay-${field}" {
      path = "services/media/syncplay";
      field = fieldAdapt field;
    }) ["pass" "salt"];

  users.users.syncplay = { isSystemUser = true; };

  users.groups."sync-cert".members = [ "nginx" "syncplay" ];
  security.acme = {
    certs."sync.${config.network.dns.domain}" = {
      group = "sync-cert";
      postRun = ''
        cp key.pem privkey.pem
        chown acme:voice-cert privkey.pem
      '';
    };
  };

  network.firewall.public.tcp.ports = singleton 8999;

  services.nginx.virtualHosts."sync.${config.network.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
  };

  deploy.tf.dns.records.services_syncplay = {
    inherit (config.network.dns) zone;
    domain = "sync";
    cname = { inherit (config.network.addresses.public) target; };
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
        "${pkgs.syncplay}/bin/syncplay-server --port 8999 --tls /var/lib/acme/sync.${config.network.dns.domain}/ --disable-ready";
      User = "syncplay";
      Group = "sync-cert";
    };
  };
}
