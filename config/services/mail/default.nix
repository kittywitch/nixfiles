{ config, lib, tf, pkgs, sources, ... }:

with lib;

let
  domains = [ "kittywitch" "dork" ];
in {
  imports = [ sources.nixos-mailserver.outPath ];

  kw.secrets.variables = listToAttrs (map (field:
    nameValuePair "mail-${field}-hash" {
      path = "secrets/mail-kittywitch";
      field = "${field}-hash";
    }) ["gitea" "kat"]
    ++ map (domain:
      nameValuePair "mail-domainkey-${domain}" {
        path = "secrets/mail-${domain}";
        field = "notes";
      }) domains);

  deploy.tf.dns.records = lib.mkMerge (map (domain: let
      zoneGet = domain: if domain == "dork" then "dork.dev." else config.network.dns.zone;
    in {
      "services_mail_${domain}_mx" = {
        zone = zoneGet domain;
        mx = {
          priority = 10;
          target = "${config.network.addresses.public.domain}.";
        };
      };

      "services_mail_${domain}_spf" = {
        zone = zoneGet domain;
        txt.value = "v=spf1 ip4:${config.network.addresses.public.nixos.ipv4.address} ip6:${config.network.addresses.public.nixos.ipv6.address} -all";
      };

      "services_mail_${domain}_dmarc" = {
        zone = zoneGet domain;
        domain = "_dmarc";
        txt.value = "v=DMARC1; p=none";
      };

      "services_mail_${domain}_domainkey" = {
        zone = zoneGet domain;
        domain = "mail._domainkey";
        txt.value = tf.variables."mail-domainkey-${domain}".ref;
      };
    }) domains);

  secrets.files = {
    mail-kat-hash = {
      text = ''
        ${tf.variables.mail-kat-hash.ref}
      '';
    };
    mail-gitea-hash = {
      text = ''
        ${tf.variables.mail-gitea-hash.ref}
      '';
    };
  };

  mailserver = {
    enable = true;
    fqdn = config.network.addresses.public.domain;
    domains = [ "kittywit.ch" "dork.dev" ];
    certificateScheme = 1;
    certificateFile = "/var/lib/acme/${config.mailserver.fqdn}/cert.pem";
    keyFile = "/var/lib/acme/${config.mailserver.fqdn}/key.pem";
    enableImap = true;
    enablePop3 = true;
    enableImapSsl = true;
    enablePop3Ssl = true;
    enableSubmission = false;
    enableSubmissionSsl = true;
    enableManageSieve = true;
    virusScanning = false;

    # nix run nixpkgs.apacheHttpd -c htpasswd -nbB "" "super secret password" | cut -d: -f2
    loginAccounts = {
      "kat@kittywit.ch" = {
        hashedPasswordFile = config.secrets.files.mail-kat-hash.path;
        aliases = [ "postmaster@kittywit.ch" ];
        catchAll = [ "kittywit.ch" "dork.dev" ];
      };
      "gitea@kittywit.ch" = {
        hashedPasswordFile = config.secrets.files.mail-gitea-hash.path;
      };
    };
  };
}
