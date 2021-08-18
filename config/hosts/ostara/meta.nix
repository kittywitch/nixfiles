{ config, lib, kw, ... }: with lib; {
  config = {
    deploy.targets.ostara = {
      tf = {
        resources.ostara = {
          provider = "null";
          type = "resource";
          connection = {
            port = head config.network.nodes.ostara.services.openssh.ports;
            host = config.network.nodes.ostara.network.addresses.private.ipv4.address;
          };
        };
      };
    };
    network.nodes.ostara = {
      imports = kw.nodeImport "ostara";
    };
  };
}
