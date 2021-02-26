{ config, pkgs, ... }:

let
  common = {
    enableACME = true;
    forceSSL = true;
  };
  secrets = (import ../../../secrets.nix);
in {
  services.nginx.virtualHosts = {
    "kittywit.ch" = { root = "/var/www/kittywitch"; } // common;
    "athame.kittywit.ch" = { root = "/var/www/athame"; } // common;
  } // secrets.virtualHosts.athame;
}
