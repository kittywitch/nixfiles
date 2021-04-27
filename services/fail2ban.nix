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
    };
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
