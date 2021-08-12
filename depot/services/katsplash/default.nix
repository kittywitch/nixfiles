{ config, pkgs, kw, ... }:

let splashy = pkgs.kat-splash config.networking.hostName; in {
  services.nginx.virtualHosts = kw.virtualHostGen {
    networkFilter = ["private"];
    block.locations."/" = { root = splashy; };
  };
}
