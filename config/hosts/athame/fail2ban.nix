{ config, pkgs, ... }:

{
  services.fail2ban = {
    enable = true;
    jails = {
      DEFAULT = ''
        bantime  = 1d
        blocktype = DROP
        logpath  = /var/log/auth.log
      '';
      asterisk = ''
        enabled  = true
        filter   = asterisk
        action   = iptables-allports[name=ASTERISK, protocol=all]
        logpath  = /var/log/asterisk/messages
        maxretry = 4
      '';
      ssh = ''
        enabled = true
        filter = sshd
        maxretry = 4
        action = iptables[name=SSH, port=ssh, protocol=tcp]
      '';
      sshd-ddos = ''
        enabled  = true
        filter = sshd-ddos
        maxretry = 4
        action   = iptables[name=ssh, port=ssh, protocol=tcp]
      '';
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

  environment.etc."fail2ban/filter.d/sshd-ddos.conf" = {
    enable = true;
    text = ''
      [Definition]
      failregex = sshd(?:\[\d+\])?: Did not receive identification string from <HOST>$
      ignoreregex =
    '';
  };

  systemd.services.fail2ban.serviceConfig.LimitSTACK = 128 * 1024;
}
