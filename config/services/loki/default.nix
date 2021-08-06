{ config, pkgs, ... }:

{
  #kw.fw.private.tcp.ports = [ 3100 ];
  services.loki = {
    enable = false;
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

}
