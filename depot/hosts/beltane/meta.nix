{ profiles, config, lib, ... }: with lib; {
  config = {
    deploy.targets.beltane = {
      tf = {
        resources.beltane = {
          provider = "null";
          type = "resource";
          connection = {
            port = 62954;
            host = config.network.nodes.beltane.network.addresses.private.ipv4.address;
          };
        };
      };
    };
    network.nodes.beltane = {
      imports = lib.hostImport {
        hostName = "beltane";
        inherit profiles;
      };
      networking = {
        hostName = "beltane";
      };
    };
  };
}

