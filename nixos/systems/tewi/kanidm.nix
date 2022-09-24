{ config, tf,... }: {
  networks.gensokyo = {
    tcp = [ 8080 636 ];
  };

  services.kanidm =  {
    enableServer = true;
    enablePam = false;
    enableClient = true;
    clientSettings = {
      uri = "https://id.gensokyo.zone";
      verify_ca = true;
      verify_hostnames = true;
    };
    serverSettings = {
      domain = "gensokyo.zone";
      origin = "https://id.gensokyo.zone";
      role = "WriteReplica";
      log_level = "default";
      db_fs_type = "zfs";
      bindaddress = "${config.networks.tailscale.ipv4}:8080";
      ldapbindaddress = "${config.networks.tailscale.ipv4}:636";
    };
  };
}
