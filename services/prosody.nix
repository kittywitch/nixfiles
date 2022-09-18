{ config, pkgs, lib, ... }:

with lib;

{
  networks.internet.tcp = [
    5000
    5222
    5223
    5269
    5280
    5281
    5347
    5582
  ];

  services.postgresql = {
    ensureDatabases = [ "prosody" ];
    ensureUsers = [{
      name = "prosody";
      ensurePermissions."DATABASE prosody" = "ALL PRIVILEGES";
    }];
  };

  services.prosody = {
    enable = true;
    ssl.cert = "/var/lib/acme/prosody/fullchain.pem";
    ssl.key = "/var/lib/acme/prosody/key.pem";
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
    '';
    virtualHosts = {
      "xmpp.${config.network.dns.domain}" = {
        domain = config.network.dns.domain;
        enabled = true;
        ssl.cert = "/var/lib/acme/prosody/fullchain.pem";
        ssl.key = "/var/lib/acme/prosody/key.pem";
      };
    };
    muc = [{ domain = "conference.${config.network.dns.domain}"; }];
    uploadHttp = { domain = "upload.${config.network.dns.domain}"; };
  };

  security.acme.certs.prosody = {
    domain = "xmpp.${config.network.dns.domain}";
    group = "prosody";
    dnsProvider = "rfc2136";
    credentialsFile = config.secrets.files.dns_creds.path;
    postRun = "systemctl restart prosody";
    extraDomainNames =
      [ config.network.dns.domain "upload.${config.network.dns.domain}" "conference.${config.network.dns.domain}" ];
  };

domains = rec {
  kittywitch-prosody = {
    network = "internet";
    type = "both";
    domain = "xmpp";
  };
  kittywitch-prosody-upload = {
    network = "internet";
    type = "cname";
    domain = "upload";
    cname.target = kittywitch-prosody.target;
  };
  kittywitch-prosody-conference = {
    network = "internet";
    type = "cname";
    domain = "conference";
    cname.target = kittywitch-prosody.target;
  };
};

  deploy.tf.dns.records = {
    services_prosody_muc = {
      inherit (config.domains.kittywitch-prosody) zone;
      domain = "conference";
      srv = {
        service = "xmpp-server";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5269;
        target = config.domains.kittywitch-prosody.target;
      };
    };

    services_prosody_client_srv = {
      inherit (config.domains.kittywitch-prosody) zone;
      domain = "@";
      srv = {
        service = "xmpp-client";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5222;
        target = config.domains.kittywitch-prosody.target;
      };
    };

    services_prosody_secure_client_srv = {
      inherit (config.domains.kittywitch-prosody) zone;
      domain = "@";
      srv = {
        service = "xmpps-client";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5223;
        target = config.domains.kittywitch-prosody.target;
      };
    };

    services_prosody_server_srv = {
      inherit (config.domains.kittywitch-prosody) zone;
      domain = "@";
      srv = {
        service = "xmpp-server";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5269;
        target = config.domains.kittywitch-prosody.target;
      };
    };
  };

  services.nginx.virtualHosts = {
    "upload.${config.network.dns.domain}" = {
      useACMEHost = "prosody";
      forceSSL = true;
    };

    "conference.${config.network.dns.domain}" = {
      useACMEHost = "prosody";
      forceSSL = true;
    };
  };

  users.users.nginx.extraGroups = [ "prosody" ];
}
