{ config, lib, pkgs, ... }:

with lib;

let
  promtail_config = pkgs.writeText "prom-config.json" (builtins.toJSON {
    clients =
      [{ url = "http://athame.net.kittywit.ch:3100/loki/api/v1/push"; }];
    positions = { filename = "/tmp/positions.yaml"; };
    scrape_configs = [{
      job_name = "journal";
      journal = {
        labels = {
          host = config.networking.hostName;
          job = "systemd-journal";
        };
        max_age = "12h";
      };
      relabel_configs = [{
        source_labels = [ "__journal__systemd_unit" ];
        target_label = "unit";
      }];
    }];
    server = {
      grpc_listen_port = 0;
      http_listen_port = 28183;
    };
  });
in
{
  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${promtail_config}
      '';
    };
  };
}
