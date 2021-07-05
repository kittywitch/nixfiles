{ config, ... }:

{
  services.postgresql = {
    ensureDatabases = [ "grafana" ];
    ensureUsers = [{
      name = "grafana";
      ensurePermissions."DATABASE grafana" = "ALL PRIVILEGES";
    }];
  };

  services.grafana = {
    enable = true;
    port = 3001;
    domain = "graph.kittywit.ch";
    rootUrl = "https://graph.kittywit.ch/";
    database = {
      type = "postgres";
      host = "/run/postgresql/";
      user = "grafana";
      name = "grafana";
    };
  };

  services.nginx.virtualHosts."graph.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:3001"; };
  };

  deploy.tf.dns.records.kittywitch_graph = {
    tld = "kittywit.ch.";
    domain = "graph";
    cname.target = "athame.kittywit.ch.";
  };
}
