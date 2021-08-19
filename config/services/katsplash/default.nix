{ config, pkgs, kw, ... }:

let splashy = pkgs.host-splash-site config.networking.hostName; in
{
  services.nginx.virtualHosts = kw.virtualHostGen {
    networkFilter = [ "private" ];
    block.locations."/" = { root = splashy; };
  };
}
