{ config, lib, kw, ... }: with lib; {
  config = {
    deploy.targets.beltane = {
      tf = {
        resources.beltane = {
          provider = "null";
          type = "resource";
          connection = {
            port = head config.network.nodes.beltane.services.openssh.ports;
            host = config.network.nodes.beltane.network.addresses.private.ipv4.address;
          };
        };
      };
    };
    network.nodes.beltane = {
      imports = kw.nodeImport "beltane";
    };
  };
}

