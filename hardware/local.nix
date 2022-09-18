{ config, lib, ... }: {
  deploy.tf.resources.${config.networking.hostName} = {
    provider = "null";
    type = "resource";
    connection = {
      port = lib.head config.services.openssh.ports;
      host = config.networks.gensokyo.ipv4 or config.networks.chitei.ipv4;
    };
  };
}
