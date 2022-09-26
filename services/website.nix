{ config, lib, pkgs, ... }:

{
  services.nginx.virtualHosts = {
    "kittywit.ch" = {
      root = pkgs.kittywitCh;
    };
  };
}
