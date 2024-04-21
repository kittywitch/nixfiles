{config, ...}: {
  users.users.telegraf = {
    extraGroups = [
      "nginx"
    ];
  };
  systemd.services.telegraf = {
    serviceConfig = {
      AmbientCapabilities = [
        "CAP_NET_RAW"
      ];
      CapabilityBoundingSet = [
        "CAP_NET_RAW"
      ];
    };
  };
  services.telegraf = {
    enable = true;
    extraConfig = {
      inputs = {
        nginx = {
          urls = [
            "http://localhost/nginx_status"
          ];
          response_timeout = "5s";
        };
        tail = {
          name_override = "nginxlog";
          files = [
            "/var/log/nginx/access.log"
          ];
          from_beginning = true;
          pipe = false;
          data_format = "grok";
          grok_patterns = ["%{COMBINED_LOG_FORMAT}"];
        };
        cpu = {
          percpu = true;
        };
        disk = {
        };
        diskio = {
        };
        net = {
        };
        mem = {
        };
        ping = {
          interval = "60s";
          method = "native";
          urls = [
            "8.8.8.8"
            "2001:4860:4860:0:0:0:0:8888"
          ];
          count = 3;
          timeout = 2.0;
        };
        system = {
        };
      };
      outputs = {
        prometheus_client = {
          listen = "127.0.0.1:9125";
        };
        http = {
          url = "http://localhost:${toString config.services.grafana.settings.server.http_port}/api/live/push/custom_stream_id";
          data_format = "influx";
          headers = {
            Authorization = "Bearer !!TELEGRAF_API_KEY!!";
          };
        };
      };
    };
  };
}
