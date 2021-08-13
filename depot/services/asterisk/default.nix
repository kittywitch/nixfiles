
{ config, lib, pkgs, tf, ... }:

with lib;

{
/*
  network.firewall.public.tcp.ports = [ 5160 5060 ];
  network.firewall.public.udp.ports = [ 5160 5060 ];

  network.firewall.public.tcp.ranges = [{
    from = 10000;
    to = 20000;
  }];

  network.firewall.public.udp.ranges = [{
    from = 10000;
    to = 20000;
  }];
  */

  services.fail2ban.jails = {
    asterisk = ''
      enabled  = true
      filter   = asterisk
      action   = nftables-allports
      logpath  = /var/log/asterisk/messages
      maxretry = 4
    '';
  };

  environment.systemPackages = with pkgs; [ asterisk ];

  users.groups.asterisk = {
    name = "asterisk";
  };

  users.users.asterisk = {
    name = "asterisk";
    group = "asterisk";
    home = "/var/lib/asterisk";
    isSystemUser = true;
  };

  systemd.services.asterisk = {
    enable = false;

    description = "Asterisk PBX Server";

    wantedBy = [ "multi-user.target" ];

    restartIfChanged = false;

    serviceConfig = {
      ExecStart = "${pkgs.asterisk}/bin/asterisk -U asterisk -C /etc/asterisk/asterisk.conf -F";
      ExecReload = "${pkgs.asterisk}/bin/asterisk -x 'core reload'";
      Type = "forking";
      PIDFile = "/run/asterisk/asterisk.pid";
    };
  };
}
