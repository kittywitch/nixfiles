{ config, lib, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "files.kittywit.ch" = {
      root = "/var/www/files";
      enableACME = true;
      forceSSL = true;
    };
  };

  deploy.tf.dns.records.kittywitch_files = {
    tld = "kittywit.ch.";
    domain = "files";
    cname.target = "athame.kittywit.ch.";
  };
}
