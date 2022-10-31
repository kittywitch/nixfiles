{ tf, config, pkgs, lib, ... }: with lib; let
ctcfg = config.services.coturn;
in {
  networks.internet = {
    extra_domains = [
      "xmpp.kittywit.ch"
      "conference.kittywit.ch"
      "upload.kittywit.ch"
      "turn.kittywit.ch"
    ];
    tcp = [
      # XMPP
      5000
      5222
      5223
      5269
      5280
      5281
      5347
      5582
      # TURN/STUN
      ctcfg.listening-port
      ctcfg.alt-listening-port
      ctcfg.tls-listening-port
      ctcfg.alt-tls-listening-port
    ];
    udp = [
      ctcfg.listening-port
      ctcfg.alt-listening-port
      ctcfg.tls-listening-port
      ctcfg.alt-tls-listening-port
      [ ctcfg.min-port ctcfg.max-port ]
    ];
  };

  services.postgresql = {
    ensureDatabases = [ "prosody" ];
    ensureUsers = [{
      name = "prosody";
      ensurePermissions."DATABASE prosody" = "ALL PRIVILEGES";
    }];
  };

  secrets = {
    variables.turn-external-secret = {
      path = "gensokyo/coturn";
      field = "static-auth";
    };
    files.turn-external-secret = {
      text = tf.variables.turn-external-secret.ref;
      owner = "prosody";
      group = "domain-auth";
    };
  };
  deploy.tf.variables.turn-external-secret.export = true;

  services.coturn = {
    enable = true;
    cert = config.networks.internet.cert_path;
    pkey = config.networks.internet.key_path;
    static-auth-secret-file = config.secrets.files.turn-external-secret.path;
    realm = "turn.kittywit.ch";
  };

  services.prosody = {
    enable = true;
    ssl.cert = config.networks.internet.cert_path;
    ssl.key = config.networks.internet.key_path;
    admins = singleton "kat@kittywit.ch";
    package =
      let
        package = pkgs.prosody.override (old: {
          withExtraLuaPackages =  p: singleton p.luadbi-postgresql;
        }); in
      package;
    extraConfig = ''
      legacy_ssl_ports = { 5223 }
        storage = "sql"
        sql = {
          driver = "PostgreSQL";
          host = "";
          database = "prosody";
          username = "prosody";
        }
        turn_external_host = "turn.kittywit.ch"
    '' + optionalString tf.state.enable ''
        turn_external_secret = "${tf.variables.turn-external-secret.get}"
    '';
    virtualHosts = {
      "xmpp.kittywit.ch" = {
        domain = "kittywit.ch";
        enabled = true;
        ssl.cert = config.networks.internet.cert_path;
        ssl.key = config.networks.internet.key_path;
      };
    };
    muc = [{ domain = "conference.kittywit.ch"; }];
    uploadHttp = { domain = "upload.kittywit.ch"; };
  };

  users.groups.domain-auth.members = [ "prosody" ];

  deploy.tf.dns.records = {
    services_prosody_muc = {
      inherit (config.networks.internet) zone;
      domain = "conference";
      srv = {
        service = "xmpp-server";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5269;
        target = config.networks.internet.target;
      };
    };

    services_prosody_client_srv = {
      inherit (config.networks.internet) zone;
      domain = "@";
      srv = {
        service = "xmpp-client";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5222;
        target = config.networks.internet.target;
      };
    };

    services_prosody_secure_client_srv = {
      inherit (config.networks.internet) zone;
      domain = "@";
      srv = {
        service = "xmpps-client";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5223;
        target = config.networks.internet.target;
      };
    };

    services_prosody_server_srv = {
      inherit (config.networks.internet) zone;
      domain = "@";
      srv = {
        service = "xmpp-server";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5269;
        target = config.networks.internet.target;
      };
    };
  };

  services.nginx.virtualHosts = {
    "upload.kittywit.ch" = {
    };

    "conference.kittywit.ch" = {
    };
  };

  users.users.nginx.extraGroups = [ "prosody" ];
}
