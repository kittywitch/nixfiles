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
