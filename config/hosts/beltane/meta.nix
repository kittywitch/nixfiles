{ lib, config, ... }: with lib; {
  config = {
    deploy.targets.beltane = {
      tf = {
        resources.beltane = {
          provider = "null";
          type = "resource";
          connection = {
            port = 62954;
            host = "192.168.1.223";
          };
        };
      };
    };
    network.nodes.beltane = {
      imports = lib.hostImport "beltane";
      networking = {
        hostName = "beltane";
      };
    };
  };
}

