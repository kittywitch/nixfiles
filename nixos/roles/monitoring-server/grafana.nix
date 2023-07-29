{
  config,
  pkgs,
  ...
}: {
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "mon.kittywit.ch";
      http_port = 2342;
      http_addr = "127.0.0.1";
    };
  };
}
