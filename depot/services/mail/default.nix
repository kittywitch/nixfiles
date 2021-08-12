{ config, lib, tf, pkgs, sources, ... }:

with lib;

{
  imports = [ sources.nixos-mailserver.outPath ];

  kw.secrets = [
    "mail-domainkey-kitty"
  ];

  deploy.tf.dns.records.services_mail_mx = {
    tld = config.network.dns.tld;
    domain = "@";
    mx = {
      priority = 10;
      target = config.network.addresses.public.domain;
    };
  };

  deploy.tf.dns.records.services_mail_spf = {
    tld = config.network.dns.tld;
    domain = "@";
    txt.value = "v=spf1 ip4:${config.network.addresses.public.ipv4.address} ip6:${config.network.addresses.public.ipv6.address} -all";
  };

  deploy.tf.dns.records.services_mail_dmarc = {
    tld = config.network.dns.tld;
    domain = "_dmarc";
    txt.value = "v=DMARC1; p=none";
  };

  deploy.tf.dns.records.services_mail_domainkey = {
    tld = config.network.dns.tld;
    domain = "mail._domainkey";
    txt.value = tf.variables.mail-domainkey-kitty.ref;
  };

  mailserver = {
    enable = true;
    fqdn = config.network.addresses.public.domain;
    domains = [ "kittywit.ch" "dork.dev" ];
    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 1;
    certificateFile = "/var/lib/acme/${config.mailserver.fqdn}/cert.pem";
    keyFile = "/var/lib/acme/${config.mailserver.fqdn}/key.pem";

    # Enable IMAP and POP3
    enableImap = true;
    enablePop3 = true;
    enableImapSsl = true;
    enablePop3Ssl = true;
    enableSubmission = false;
    enableSubmissionSsl = true;

    # Enable the ManageSieve protocol
    enableManageSieve = true;

    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;
  };
}
