{ config, lib, tf, pkgs, sources, ... }:

with lib;

{
  imports = [ sources.nixos-mailserver.outPath ];

  services.fail2ban.jails = {
    postfix = ''
      enabled  = true
      filter   = postfix
      maxretry = 3
      action   = iptables[name=postfix, port=smtp, protocol=tcp]
    '';
    postfix-sasl = ''
      enabled  = true
      filter   = postfix-sasl
      port     = postfix,imap3,imaps,pop3,pop3s
      maxretry = 3
      action   = iptables[name=postfix, port=smtp, protocol=tcp]
    '';
    postfix-ddos = ''
      enabled  = true
      filter   = postfix-ddos
      maxretry = 3
      action   = iptables[name=postfix, port=submission, protocol=tcp]
      bantime  = 7200
    '';
  };

  environment.etc."fail2ban/filter.d/postfix-sasl.conf" = {
    enable = true;
    text = ''
      # Fail2Ban filter for postfix authentication failures
      [INCLUDES]
      before = common.conf
      [Definition]
      daemon = postfix/smtpd
      failregex = ^%(__prefix_line)swarning: [-._\w]+\[<HOST>\]: SASL (?:LOGIN|PLAIN|(?:CRAM|DIGEST)-MD5) authentication failed(: [ A-Za-z0-9+/]*={0,2})?\s*$
    '';
  };

  environment.etc."fail2ban/filter.d/postfix-ddos.conf" = {
    enable = true;
    text = ''
      [Definition]
      failregex = lost connection after EHLO from \S+\[<HOST>\]
    '';
  };

  deploy.tf.variables.domainkey_kitty = {
    type = "string";
    value.shellCommand = "bitw get infra/domainkey-kitty";
  };

  deploy.tf.dns.records.kittywitch_mx = {
    tld = "kittywit.ch.";
    domain = "@";
    mx = {
      priority = 10;
      target = "athame.kittywit.ch.";
    };
  };

  deploy.tf.dns.records.kittywitch_spf = {
    tld = "kittywit.ch.";
    domain = "@";
    txt.value = "v=spf1 ip4:168.119.126.111 ip6:${
        (head config.networking.interfaces.enp1s0.ipv6.addresses).address
      } -all";
  };

  deploy.tf.dns.records.kittywitch_dmarc = {
    tld = "kittywit.ch.";
    domain = "_dmarc";
    txt.value = "v=DMARC1; p=none";
  };

  deploy.tf.dns.records.kittywitch_domainkey = {
    tld = "kittywit.ch.";
    domain = "mail._domainkey";
    txt.value = tf.variables.domainkey_kitty.ref;
  };

  mailserver = {
    enable = true;
    fqdn = "athame.kittywit.ch";
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
