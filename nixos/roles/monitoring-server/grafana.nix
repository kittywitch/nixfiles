{
  config,
  pkgs,
  ...
}: {
  services.grafana = {
    enable = true;
    domain = "mon.kittywit.ch";
    port = 2342;
    addr = "127.0.0.1";
  };
}
