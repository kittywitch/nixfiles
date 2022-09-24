{ config, pkgs, lib, ... }:

with lib;

{
  networks.internet = {
    extra_domains = [
      "xmpp.kittywit.ch"
      "conference.kittywit.ch"
      "upload.kittywit.ch"
    ];
    tcp = [
      5000
      5222
      5223
      5269
      5280
      5281
      5347
      5582
    ];
  };

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
      "xmpp.kittywit.ch" = {
        domain = config.network.dns.domain;
        enabled = true;
        ssl.cert = "/var/lib/acme/prosody/fullchain.pem";
        ssl.key = "/var/lib/acme/prosody/key.pem";
      };
    };
    muc = [{ domain = "conference.kittywit.ch"; }];
    uploadHttp = { domain = "upload.kittywit.ch"; };
  };

  users.groups.domain-auth.members = [ "prosody" ];

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
    "upload.kittywit.ch" = {
    };

    "conference.kittywit.ch" = {
    };
  };

  users.users.nginx.extraGroups = [ "prosody" ];
}
