{ config, lib, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "${config.network.dns.domain}" = {
      root = pkgs.kat-website;
      enableACME = true;
      forceSSL = true;
    };
  };
}
