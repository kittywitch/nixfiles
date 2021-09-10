{ config, lib, meta, kw, tf, ... }: with lib;

let
  cfg = config.kw.monitoring;
  prom_configs =
    (mapAttrs (hostName: host: host.services.prometheus.exporters.node)
      (filterAttrs
        (_: host: host.services.prometheus.exporters.node.enable)
        meta.network.nodes));
  nd_configs = (mapAttrs (hostName: host: host.services.netdata)
    (filterAttrs (_: host: host.services.netdata.enable) meta.network.nodes));
in
{
  options.kw.monitoring = {
    server = {
      enable = mkEnableOption "Monitoring Stack Server";
      loki = mkEnableOption "Loki";
      domainPrefix = mkOption {
        type = types.nullOr types.str;
      };
    };
    client = {
      enable = mkEnableOption "Monitoring Stack Client" // {
        default = config.network.yggdrasil.enable && config.services.nginx.enable;
      };
    };
  };
  config = mkMerge [
    ({
      kw.monitoring.server.domainPrefix = ".${config.network.addresses.yggdrasil.prefix}.${config.network.dns.domain}";
    })
    (mkIf cfg.server.loki {
      network.firewall.private.tcp.ports = [ 3100 ];
      services.loki = {
        enable = true;
        configuration = {
          auth_enabled = false;
          chunk_store_config = { max_look_back_period = "0s"; };
          ingester = {
            chunk_idle_period = "1h";
            chunk_retain_period = "30s";
            chunk_target_size = 1048576;
            lifecycler = {
              address = "0.0.0.0";
              final_sleep = "0s";
              ring = {
                kvstore = { store = "inmemory"; };
                replication_factor = 1;
              };
            };
            max_chunk_age = "1h";
            max_transfer_retries = 0;
          };
          limits_config = {
            reject_old_samples = true;
            reject_old_samples_max_age = "168h";
          };
          schema_config = {
            configs = [{
              from = "2020-10-24";
              index = {
                period = "24h";
                prefix = "index_";
              };
              object_store = "filesystem";
              schema = "v11";
              store = "boltdb-shipper";
            }];
          };
          compactor = {
            working_directory = "/tmp/loki-compactor-boltdb";
            shared_store = "filesystem";
          };
          server = { http_listen_port = 3100; };
          storage_config = {
            boltdb_shipper = {
              active_index_directory = "/var/lib/loki/boltdb-shipper-active";
              cache_location = "/var/lib/loki/boltdb-shipper-cache";
              cache_ttl = "24h";
              shared_store = "filesystem";
            };
            filesystem = { directory = "/var/lib/loki/chunks"; };
          };
          table_manager = {
            retention_deletes_enabled = false;
            retention_period = "0s";
          };
        };
      };
    })
    (mkIf cfg.server.enable {
      network.firewall.private.tcp.ports = [ 9090 ];

      secrets.files.grafana-admin-pass = {
        text = "${tf.variables.grafana-admin.ref}";
        owner = "grafana";
        group = "grafana";
      };

      services.grafana.security.adminPasswordFile =
        config.secrets.files.grafana-admin-pass.path;

      services.postgresql = {
        ensureDatabases = [ "grafana" ];
        ensureUsers = [{
          name = "grafana";
          ensurePermissions."DATABASE grafana" = "ALL PRIVILEGES";
        }];
      };

      kw.secrets.variables = (mapListToAttrs
        (field:
          nameValuePair "grafana-${field}" {
            path = "secrets/grafana";
            inherit field;
          }) [ "secret" "admin" ]);

      secrets.files.grafana-env = {
        text = ''
          GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET=${tf.variables.grafana-secret.ref}
        '';
        owner = "grafana";
        group = "grafana";
      };

      systemd.services.grafana.serviceConfig = {
        EnvironmentFile = config.secrets.files.grafana-env.path;
      };

      services.grafana = {
        enable = true;
        port = 3001;
        domain = "graph.${config.network.dns.domain}";
        rootUrl = "https://graph.${config.network.dns.domain}/";
        extraOptions = {
          AUTH_GENERIC_OAUTH_ENABLED = "true";
          AUTH_GENERIC_OAUTH_NAME = "Keycloak";
          AUTH_GENERIC_OAUTH_CLIENT_ID = "grafana";
          AUTH_GENERIC_OAUTH_ALLOW_SIGN_UP = "true";
          AUTH_GENERIC_OAUTH_AUTH_URL = "https://auth.kittywit.ch/auth/realms/kittywitch/protocol/openid-connect/auth";
          AUTH_GENERIC_OAUTH_TOKEN_URL = "https://auth.kittywit.ch/auth/realms/kittywitch/protocol/openid-connect/token";
          AUTH_GENERIC_OAUTH_API_URL = "https://auth.kittywit.ch/auth/realms/kittywitch/protocol/openid-connect/userinfo";
          AUTH_GENERIC_OAUTH_ROLE_ATTRIBUTE_PATH = "contains(realm_access.roles[*], 'Admin') && 'Admin' || contains(realm_access.roles[*], 'Editor') && 'Editor' || 'Admin'";
          AUTH_GENERIC_OAUTH_SCOPES = "openid profile email";
          AUTH_GENERIC_OAUTH_EMAIL_ATTRIBUTE_NAMEs = "email:primary";
        };
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
        inherit (config.network.dns) zone;
        domain = "graph";
        cname = { inherit (config.network.addresses.public) target; };
      };

      services.prometheus = {
        enable = true;
        scrapeConfigs = mapAttrsToList
          (hostName: prom: {
            job_name = "${hostName}-nd";
            metrics_path = "/api/v1/allmetrics";
            honor_labels = true;
            params = { format = [ "prometheus" ]; };
            static_configs = singleton { targets = singleton "${hostName}${cfg.server.domainPrefix}:19999"; };
          })
          nd_configs ++ mapAttrsToList
          (hostName: prom: {
            job_name = hostName;
            static_configs = singleton {
              targets = [ "${hostName}${cfg.server.domainPrefix}:${toString prom.port}" ];
            };
          })
          prom_configs;
      };
    })
    (mkIf cfg.client.enable {
      network.firewall.private.tcp.ports = [ 19999 9002 ];

      services.netdata.enable = true;

      services.nginx.virtualHosts = kw.virtualHostGen {
        networkFilter = singleton "yggdrasil";
        block = {
          locations."/netdata" = {
            proxyPass = "http://[::1]:19999/";
          };
        };
      };

      systemd.services.promtail = {
        enable = any id (attrValues (mapAttrs (node: conf: conf.kw.monitoring.server.loki) meta.network.nodes));
        description = "Promtail service for Loki";
        wantedBy = [ "multi-user.target" ];
        wants = [ "yggdrassil.service" ];

        serviceConfig = mkIf (any id (attrValues (mapAttrs (node: conf: conf.kw.monitoring.server.loki) meta.network.nodes))) {
          ExecStart =
            let
              serverNode = head (attrNames (filterAttrs (node: enabled: enabled == true) (mapAttrs (node: conf: conf.kw.monitoring.server.loki) meta.network.nodes)));
              promtailConfig = pkgs.writeText "prom-config.json" (builtins.toJSON {
                clients =
                  [{ url = "http://${serverNode}${cfg.server.domainPrefix}:3100/loki/api/v1/push"; }];
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
            ''
              ${pkgs.grafana-loki}/bin/promtail --config.file ${promtailConfig}
            '';
        };
      };

      services.prometheus = {
        exporters = {
          node = {
            enable = true;
            enabledCollectors = [ "systemd" ];
            port = 9002;
          };
        };
      };
    })
  ];
}
