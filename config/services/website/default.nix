{ config, lib, pkgs, ... }:

{
  network.dns.isRoot = true;

  services.nginx.virtualHosts = {
    "${config.network.dns.domain}" = {
      root = pkgs.kittywitch-site;
      enableACME = true;
      forceSSL = true;
    };
  };
}
