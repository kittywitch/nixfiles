{config, ...}: {
  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9002;
      };
      domain = {
        enable = true;
      };
    };
    ruleFiles = [
      ./synapse-v2.rules
    ];
    scrapeConfigs = [
      {
        job_name = "${config.networking.hostName}";
        static_configs = [
          {
            targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
      {
        job_name = "domains";
        metrics_path = "/probe";
        relabel_configs = [
          {
            source_labels = ["__address__"];
            target_label = "__param_target";
          }
          {
            target_label = "__address__";
            replacement = "127.0.0.1:${toString config.services.prometheus.exporters.domain.port}";
          }
        ];
        static_configs = [
          {
            targets = [
              "dork.dev"
              "inskip.me"
              "gensokyo.zone"
            ];
          }
        ];
      }
      {
        job_name = "${config.networking.hostName}-synapse";
        metrics_path = "/_synapse/metrics";
        static_configs = [
          {
            targets = ["[::1]:8009"];
          }
        ];
      }
    ];
  };
}
