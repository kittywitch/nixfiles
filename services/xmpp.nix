{ config, pkgs, lib, ... }:

with lib;

{
  kw.fw.public.tcp.ports = [ 5000 5222 5223 5269 580 5281 5347 5582 ];

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
    admins = [ "kat@kittywit.ch" ];
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
      "xmpp.kittywit.ch" = {
        domain = "kittywit.ch";
        enabled = true;
        ssl.cert = "/var/lib/acme/prosody/fullchain.pem";
        ssl.key = "/var/lib/acme/prosody/key.pem";
      };
    };
    muc = [{ domain = "conference.kittywit.ch"; }];
    uploadHttp = { domain = "upload.kittywit.ch"; };
  };

  security.acme.certs.prosody = {
    domain = "xmpp.kittywit.ch";
    group = "prosody";
    dnsProvider = "rfc2136";
    credentialsFile = config.secrets.files.dns_creds.path;
    postRun = "systemctl restart prosody";
    extraDomainNames =
      [ "kittywit.ch" "upload.kittywit.ch" "conference.kittywit.ch" ];
  };

  deploy.tf.dns.records.kittywitch_xmpp = {
    tld = "kittywit.ch.";
    domain = "xmpp";
    a.address = "168.119.126.111";
  };

  deploy.tf.dns.records.kittywitch_xmpp_v6 = {
    tld = "kittywit.ch.";
    domain = "xmpp";
    aaaa.address =
      (lib.head config.networking.interfaces.enp1s0.ipv6.addresses).address;
  };

  deploy.tf.dns.records.kittywitch_upload = {
    tld = "kittywit.ch.";
    domain = "upload";
    cname.target = "xmpp.kittywit.ch.";
  };

  deploy.tf.dns.records.kittywitch_conference = {
    tld = "kittywit.ch.";
    domain = "conference";
    cname.target = "xmpp.kittywit.ch.";
  };

  deploy.tf.dns.records.kittywitch_xmpp_muc = {
    tld = "kittywit.ch.";
    domain = "conference";
    srv = {
      service = "xmpp-server";
      proto = "tcp";
      priority = 0;
      weight = 5;
      port = 5269;
      target = "xmpp.kittywit.ch.";
    };
  };

  deploy.tf.dns.records.kittywitch_xmpp_client = {
    tld = "kittywit.ch.";
    domain = "@";
    srv = {
      service = "xmpp-client";
      proto = "tcp";
      priority = 0;
      weight = 5;
      port = 5222;
      target = "xmpp.kittywit.ch.";
    };
  };

  deploy.tf.dns.records.kittywitch_xmpps_client = {
    tld = "kittywit.ch.";
    domain = "@";
    srv = {
      service = "xmpps-client";
      proto = "tcp";
      priority = 0;
      weight = 5;
      port = 5223;
      target = "xmpp.kittywit.ch.";
    };
  };

  deploy.tf.dns.records.kittywitch_xmpp_server = {
    tld = "kittywit.ch.";
    domain = "@";
    srv = {
      service = "xmpp-server";
      proto = "tcp";
      priority = 0;
      weight = 5;
      port = 5269;
      target = "xmpp.kittywit.ch.";
    };
  };

  services.nginx.virtualHosts = {
    "upload.kittywit.ch" = {
      useACMEHost = "prosody";
      forceSSL = true;
    };

    "conference.kittywit.ch" = {
      useACMEHost = "prosody";
      forceSSL = true;
    };
  };
  users.users.nginx.extraGroups = [ "prosody" ];
}
