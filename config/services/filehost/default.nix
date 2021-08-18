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
    tld = config.network.dns.tld;
    domain = "files";
    cname.target = "${config.networking.hostName}.${config.network.dns.tld}";
  };
}
