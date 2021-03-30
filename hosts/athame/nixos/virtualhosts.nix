{ config, pkgs, witch, ... }:

let
  common = {
    enableACME = true;
    forceSSL = true;
  };
in {
  services.nginx.virtualHosts = {
    "kittywit.ch" = { root = pkgs.kat-website; } // common;
    "athame.kittywit.ch" = { root = "/var/www/athame"; } // common;
    "files.kittywit.ch" = { root = "/var/www/files"; } // common;
  } // witch.secrets.virtualHosts.athame;

  deploy.tf.dns.records.kittywitch_files = {
    tld = "kittywit.ch.";
    domain = "files";
    cname.target = "athame.kittywit.ch.";
  };
}
