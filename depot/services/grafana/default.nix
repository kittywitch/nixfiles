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
    domain = "graph.${config.network.dns.domain}";
    rootUrl = "https://graph.${config.network.dns.domain}/";
    database = {
      type = "postgres";
      host = "/run/postgresql/";
      user = "grafana";
      name = "grafana";
    };
  };

  services.nginx.virtualHosts."graph.${config.network.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:3001"; };
  };

  deploy.tf.dns.records.services_grafana = {
    tld = config.network.dns.tld;
    domain = "graph";
    cname.target = "${config.networking.hostName}.${config.network.dns.tld}";
  };
}
