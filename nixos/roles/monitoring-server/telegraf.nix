{config, ...}: {
  users.users.telegraf = {
    extraGroups = [
      "nginx"
    ];
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
        io = {
        };
        net = {
        };
        mem = {
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
