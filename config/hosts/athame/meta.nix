{ config, lib, kw, ... }: with lib; {
  deploy.targets.infra = {
    tf = {
      resources.athame = {
        provider = "null";
        type = "resource";
        connection = {
          port = head config.network.nodes.athame.services.openssh.ports;
          host = config.network.nodes.athame.network.addresses.public.ipv4.address;
        };
      };
    };
  };
  network.nodes.athame = {
    imports = kw.nodeImport "athame";
  };
}
