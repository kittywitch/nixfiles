{ config, lib, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "kittywit.ch" = {
      root = pkgs.gensokyoZone;
      enableACME = true;
      forceSSL = true;
    };
  };
}
