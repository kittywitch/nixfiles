{ config, pkgs, ... }:

{
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.nextcloud = {
    enable = true;
    hostName = "files.kittywit.ch";
    package = pkgs.nextcloud21;
    https = true;
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      adminpassFile =
        config.secrets.files.nextcloud.path; # TODO replace this with proper secrets management
      adminuser = "root";
    };
  };

  services.nginx.virtualHosts."files.kittywit.ch" = {
    forceSSL = true;
    enableACME = true;
  };
}
