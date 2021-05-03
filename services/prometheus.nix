{ config, hosts, lib, ... }:

with lib;

let
  prom_configs =
    (mapAttrs (hostName: host: host.config.services.prometheus.exporters.node)
      (filterAttrs
        (_: host: host.config.services.prometheus.exporters.node.enable)
        hosts));
in {
  services.prometheus = {
    enable = true;
    scrapeConfigs = [ 
      {
        job_name = "boline";
        static_configs = [{ targets = [ "boline.net.kittywit.ch:8002" ];}];
      }
    ] ++ mapAttrsToList (hostName: prom: {
      job_name = hostName;
      static_configs = [{
        targets = [ "${hostName}.net.kittywit.ch:${toString prom.port}" ];
      }];
    }) prom_configs;
  };
}

