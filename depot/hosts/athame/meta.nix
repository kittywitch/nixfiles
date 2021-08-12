{ profiles, lib, config, ... }: with lib; {
config = {
    deploy.targets.infra = {
      tf = {
        resources.athame = {
          provider = "null";
          type = "resource";
          connection = {
            port = 62954;
            host = config.network.nodes.athame.network.addresses.public.ipv4.address;
          };
        };
      };
    };
    network.nodes.athame = {
      imports = lib.hostImport {
        hostName = "athame";
        inherit profiles;
      };
      networking = {
        hostName = "athame";
      };
    };
  };
}
