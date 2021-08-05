{ config, lib, tf, pkgs, sources, ... }:

with lib;

{
  imports = [ sources.nixos-mailserver.outPath ];

  deploy.tf.variables.domainkey_kitty = {
    type = "string";
    value.shellCommand = "bitw get infra/domainkey-kitty";
  };

  deploy.tf.dns.records.services_mail_mx = {
    tld = config.kw.dns.tld;
    domain = "@";
    mx = {
      priority = 10;
      target = "${config.networking.hostName}.${config.kw.dns.tld}";
    };
  };

  deploy.tf.dns.records.services_mail_spf = {
    tld = config.kw.dns.tld;
    domain = "@";
    txt.value = "v=spf1 ip4:${config.kw.dns.ipv4} ip6:${config.kw.dns.ipv6} -all";
  };

  deploy.tf.dns.records.services_mail_dmarc = {
    tld = config.kw.dns.tld;
    domain = "_dmarc";
    txt.value = "v=DMARC1; p=none";
  };

  deploy.tf.dns.records.services_mail_domainkey = {
    tld = config.kw.dns.tld;
    domain = "mail._domainkey";
    txt.value = tf.variables.domainkey_kitty.ref;
  };

  mailserver = {
    enable = true;
    fqdn = "${config.networking.hostName}.${config.kw.dns.domain}";
    domains = [ "kittywit.ch" "dork.dev" ];
    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = 3;

    # Enable IMAP and POP3
    enableImap = true;
    enablePop3 = true;
    enableImapSsl = true;
    enablePop3Ssl = true;

    # Enable the ManageSieve protocol
    enableManageSieve = true;

    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;
  };
}
