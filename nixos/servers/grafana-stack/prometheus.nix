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
      postgres = {
        enable = true;
        port = 9187;
        runAsLocalSuperUser = true;
        extraFlags = ["--auto-discover-databases"];
      };
      domain = {
        enable = true;
      };
      nginx = {
        enable = true;
        sslVerify = false;
      };
    };
    ruleFiles = [
    ];
    scrapeConfigs = [
      {
        job_name = "tewi-hass";
        scrape_interval = "60s";
        metrics_path = "/api/prometheus";
        scheme = "https";
        bearer_token = "!!HOME_ASSISTANT_API_TOKEN!!";
        static_configs = [
          {
            targets = ["home.gensokyo.zone:443"];
          }
        ];
      }
      {
        job_name = "${config.networking.hostName}";
        static_configs = [
          {
            targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
      {
        job_name = "${config.networking.hostName}-telegraf";
        static_configs = [
          {
            targets = ["127.0.0.1:9125"];
          }
        ];
      }
      {
        job_name = "${config.networking.hostName}-postgres";
        static_configs = [
          {
            targets = ["127.0.0.1:${toString config.services.prometheus.exporters.postgres.port}"];
          }
        ];
      }
      {
        job_name = "${config.networking.hostName}-nginx";
        static_configs = [
          {
            targets = ["127.0.0.1:${toString config.services.prometheus.exporters.nginx.port}"];
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
    ];
  };
}
