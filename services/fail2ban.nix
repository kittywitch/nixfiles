{ config, pkgs, ... }:

{
  services.fail2ban = {
    enable = true;
    packageFirewall = pkgs.nftables;
    banaction = "nftables-multiport";
    banaction-allports = "nftables-allports";
    jails = {
      default = ''
        bantime  = 7d
        blocktype = DROP
        action = nftables-allports
        logpath = /var/log/auth.log
      '';
      ssh = ''
        enabled = true
        filter = sshd
        maxretry = 4
        action = nftables-multiport[name=SSH, port=ssh, protocol=tcp]
      '';
      sshd-ddos = ''
        enabled  = true
        filter = sshd-ddos
        maxretry = 4
        action   = nftables-multiport[name=ssh, port=ssh, protocol=tcp]
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
