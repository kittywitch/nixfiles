{ config, lib, pkgs, ... }:

{
  network.dns.isRoot = true;

  services.nginx.virtualHosts = {
    "${config.network.dns.domain}" = {
      root = pkgs.kat-hugosite;
      enableACME = true;
      forceSSL = true;
    };

  };
}
