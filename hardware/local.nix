{ config, lib, ... }: {
  deploy.tf.resources.${config.networking.hostName} = {
    provider = "null";
    type = "resource";
    connection = {
      port = lib.head config.services.openssh.ports;
      host = if config.networks.gensokyo.interfaces != [] then config.networks.gensokyo.ipv4 else config.networks.chitei.ipv4;
    };
  };
}
