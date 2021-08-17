{ config, lib, kw, ... }: with lib; {
  config = {
    deploy.targets.personal = {
      tf = {
        resources.samhain = {
          provider = "null";
          type = "resource";
          connection = {
            port = head config.network.nodes.samhain.services.openssh.ports;
            host = config.network.nodes.samhain.network.addresses.private.ipv4.address;
          };
        };
      };
    };
    network.nodes.samhain = {
      imports = kw.nodeImport "samhain";
    };
  };
}
