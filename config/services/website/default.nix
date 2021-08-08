{ config, lib, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "${config.kw.dns.domain}" = {
      root = pkgs.kat-website;
      enableACME = true;
      forceSSL = true;
    };
  };
}
