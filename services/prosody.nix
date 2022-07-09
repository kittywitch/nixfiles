{ config, pkgs, lib, ... }:

with lib;

{
  network.firewall.public.tcp.ports = [
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

  deploy.tf.dns.records = {
    services_prosody_xmpp = {
      inherit (config.network.dns) zone;
      domain = "xmpp";
      a.address = config.network.addresses.public.nixos.ipv4.selfaddress;
    };

    services_prosody_xmpp_v6 = {
      inherit (config.network.dns) zone;
      domain = "xmpp";
      aaaa.address = config.network.addresses.public.nixos.ipv6.selfaddress;
    };

    services_prosody_upload = {
      inherit (config.network.dns) zone;
      domain = "upload";
      cname.target = "xmpp.${config.network.dns.zone}";
    };

    services_prosody_conference = {
      inherit (config.network.dns) zone;
      domain = "conference";
      cname.target = "xmpp.${config.network.dns.zone}";
    };

    services_prosody_muc = {
      inherit (config.network.dns) zone;
      domain = "conference";
      srv = {
        service = "xmpp-server";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5269;
        target = "xmpp.${config.network.dns.zone}";
      };
    };

    services_prosody_client_srv = {
      inherit (config.network.dns) zone;
      domain = "@";
      srv = {
        service = "xmpp-client";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5222;
        target = "xmpp.${config.network.dns.zone}";
      };
    };

    services_prosody_secure_client_srv = {
      inherit (config.network.dns) zone;
      domain = "@";
      srv = {
        service = "xmpps-client";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5223;
        target = "xmpp.${config.network.dns.zone}";
      };
    };

    services_prosody_server_srv = {
      inherit (config.network.dns) zone;
      domain = "@";
      srv = {
        service = "xmpp-server";
        proto = "tcp";
        priority = 0;
        weight = 5;
        port = 5269;
        target = "xmpp.${config.network.dns.zone}";
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
