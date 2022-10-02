{ config, lib, pkgs, tf, ... }:

with lib;

{

  secrets.variables =
    let
      fieldAdapt = field: if field == "pass" then "password" else field;
    in
    mapListToAttrs
      (field:
        nameValuePair "syncplay-${field}" {
          path = "services/media/syncplay";
          field = fieldAdapt field;
        }) [ "pass" "salt" ];


  users.users.syncplay = { isSystemUser = true; group = "domain-auth"; };
  users.groups."domain-auth".members = [ "syncplay" ];

  networks.internet.tcp = [ 8999 ];

  domains.kittywitch-syncplay = {
    network = "internet";
    type = "cname";
    domain = "sync";
  };

  secrets.files.syncplay-env = {
    text = ''
      SYNCPLAY_PASSWORD=${tf.variables.syncplay-pass.ref}
      SYNCPLAY_SALT=${tf.variables.syncplay-salt.ref}
    '';
    owner = "syncplay";
    group = "domain-auth";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/syncplay 0711 syncplay domain-auth 90"
  ];

  networks.internet = {
    extra_domains = [
      "sync.kittywit.ch"
    ];
  };

  systemd.services.syncplay = {
    description = "Syncplay Service";
    wantedBy = singleton "multi-user.target";
    after = singleton "network-online.target";
    preStart = ''
    cp ${config.networks.internet.cert_path} /var/lib/syncplay/fullchain.pem
    cp ${config.networks.internet.key_path} /var/lib/syncplay/privkey.pem
    '';
    serviceConfig = {
      EnvironmentFile = config.secrets.files.syncplay-env.path;
      ExecStart =
        "${pkgs.syncplay}/bin/syncplay-server --port 8999 --tls /var/lib/syncplay --disable-ready";
      User = "syncplay";
      Group = "domain-auth";
    };
  };
}
