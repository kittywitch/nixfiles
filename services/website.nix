{ config, lib, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "${config.network.dns.domain}" = {
      root = pkgs.gensokyoZone;
      enableACME = true;
      forceSSL = true;
    };
  };
}
