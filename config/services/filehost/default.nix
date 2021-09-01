{ config, lib, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "files.${config.network.dns.domain}" = {
      root = "/var/www/files";
      enableACME = true;
      forceSSL = true;
    };
  };

  deploy.tf.dns.records.services_filehost = {
    inherit (config.network.dns) zone;
    domain = "files";
    cname = { inherit (config.network.addresses.public) target; };
  };
}
