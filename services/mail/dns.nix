{ config, pkgs, lib, tf, ... }: with lib; let
  domains = [ "dork" "kittywitch" ];
in {

  kw.secrets.variables = listToAttrs (map
    (domain:
      nameValuePair "mail-domainkey-${domain}" {
        path = "secrets/mail-${domain}";
        field = "notes";
      })
      domains);

  deploy.tf.dns.records = mkMerge (map
    (domain:
      let
        zoneGet = domain: if domain == "dork" then "dork.dev." else config.networks.internet.zone;
      in
      {
        "services_mail_${domain}_autoconfig_cname" = {
          zone = zoneGet domain;
          domain = "autoconfig";
          cname = { inherit (config.networks.internet) target; };
        };

        "services_mail_${domain}_mx" = {
          zone = zoneGet domain;
          mx = {
            priority = 10;
            inherit (config.networks.internet) target;
          };
        };

        "services_mail_${domain}_spf" = {
          zone = zoneGet domain;
          txt.value = "v=spf1 ip4:${config.networks.internet.ipv4} ip6:${config.networks.internet.ipv6} -all";
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
      })
      domains);
}
