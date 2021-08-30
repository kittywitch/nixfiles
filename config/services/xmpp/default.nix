{ config, pkgs, lib, ... }:

with lib;

{
  network.firewall.public.tcp.ports = [ 5000 5222 5223 5269 580 5281 5347 5582 ];

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
          withExtraLibs = old.withExtraLibs ++ singleton pkgs.luaPackages.luadbi-postgresql;
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

  deploy.tf.dns.records.services_prosody_xmpp = {
    tld = config.network.dns.tld;
    domain = "xmpp";
    a.address = config.network.addresses.public.nixos.ipv4.address;
  };

  deploy.tf.dns.records.services_prosody_xmpp_v6 = {
    tld = config.network.dns.tld;
    domain = "xmpp";
    aaaa.address = config.network.addresses.public.nixos.ipv6.address;
  };

  deploy.tf.dns.records.services_prosody_upload = {
    tld = config.network.dns.tld;
    domain = "upload";
    cname.target = "xmpp.${config.network.dns.tld}";
  };

  deploy.tf.dns.records.services_prosody_conference = {
    tld = config.network.dns.tld;
    domain = "conference";
    cname.target = "xmpp.${config.network.dns.tld}";
  };

  deploy.tf.dns.records.services_prosody_muc = {
    tld = config.network.dns.tld;
    domain = "conference";
    srv = {
      service = "xmpp-server";
      proto = "tcp";
      priority = 0;
      weight = 5;
      port = 5269;
      target = "xmpp.${config.network.dns.tld}";
    };
  };

  deploy.tf.dns.records.services_prosody_client_srv = {
    tld = config.network.dns.tld;
    domain = "@";
    srv = {
      service = "xmpp-client";
      proto = "tcp";
      priority = 0;
      weight = 5;
      port = 5222;
      target = "xmpp.${config.network.dns.tld}";
    };
  };

  deploy.tf.dns.records.services_prosody_secure_client_srv = {
    tld = config.network.dns.tld;
    domain = "@";
    srv = {
      service = "xmpps-client";
      proto = "tcp";
      priority = 0;
      weight = 5;
      port = 5223;
      target = "xmpp.${config.network.dns.tld}";
    };
  };

  deploy.tf.dns.records.services_prosody_server_srv = {
    tld = config.network.dns.tld;
    domain = "@";
    srv = {
      service = "xmpp-server";
      proto = "tcp";
      priority = 0;
      weight = 5;
      port = 5269;
      target = "xmpp.${config.network.dns.tld}";
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
