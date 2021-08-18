{ config, lib, kw, ... }: with lib; {
  config = {
    deploy.targets.personal = {
      tf = {
        resources.yule = {
          provider = "null";
          type = "resource";
          connection = {
            port = head config.network.nodes.yule.services.openssh.ports;
            host = config.network.nodes.yule.network.addresses.private.ipv4.address;
          };
        };
      };
    };
    network.nodes.yule = {
      imports = kw.nodeImport "yule";
    };
  };
}
