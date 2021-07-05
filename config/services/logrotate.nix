{ config, lib, ... }:

with lib;

{
  services.logrotate = {
    enable = true;
    paths = {
      nginx = mkIf config.services.nginx.enable {
        path = "/var/log/nginx/*.log";
        user = "nginx";
        group = "nginx";
        frequency = "weekly";
        keep = 2;
      };
      asterisk = mkIf config.systemd.services.asterisk.enable {
        path = "/var/log/asterisk/messages";
        user = "asterisk";
        group = "asterisk";
        frequency = "daily";
        keep = 2;
      };
    };
  };
}
