{ config, hosts, lib, ... }:

with lib;

let
  prom_configs =
    (mapAttrs (hostName: host: host.config.services.prometheus.exporters.node)
      (filterAttrs
        (_: host: host.config.services.prometheus.exporters.node.enable)
        hosts));
  nd_configs = (mapAttrs (hostName: host: host.config.services.netdata)
    (filterAttrs (_: host: host.config.services.netdata.enable) hosts));
in
{
  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "boline";
        static_configs = [{ targets = [ "boline.${config.network.addresses.yggdrasil.prefix}.${config.network.dns.domain}:8002" ]; }];
      }
      {
        job_name = "samhain-vm";
        metrics_path = "/metrics";
        static_configs = [{ targets = [ "samhain.${config.network.addresses.yggdrasil.prefix}.${config.network.dns.domain}:10445" ]; }];
      }
    ] ++ mapAttrsToList
      (hostName: prom: {
        job_name = "${hostName}-nd";
        metrics_path = "/api/v1/allmetrics";
        honor_labels = true;
        params = { format = [ "prometheus" ]; };
        static_configs = [{ targets = [ "${hostName}.${config.network.addresses.yggdrasil.prefix}.${config.network.dns.domain}:19999" ]; }];
      })
      nd_configs ++ mapAttrsToList
      (hostName: prom: {
        job_name = hostName;
        static_configs = [{
          targets = [ "${hostName}.${config.network.addresses.yggdrasil.prefix}.${config.network.dns.domain}:${toString prom.port}" ];
        }];
      })
      prom_configs;
  };
}

