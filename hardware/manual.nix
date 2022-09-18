{ config, lib, ... }: {
  deploy.tf = {
    resources.${config.networking.hostName} = {
      provider = "null";
      type = "resource";
      connection = {
        port = lib.head config.services.openssh.ports;
        host = config.networks.internet.ipv4;
      };
    };
  };
}
