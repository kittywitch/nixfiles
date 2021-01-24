{ config, pkgs, ... }:

{
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.nextcloud = {
    enable = true;
    hostName = "fs.dork.dev";
    https = true;
    nginx.enable = true;
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      adminpassFile =
        "/var/lib/nextcloud/admin_pass"; # TODO replace this with proper secrets management
      adminuser = "root";
    };
  };
}
