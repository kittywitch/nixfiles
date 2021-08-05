{ lib, config, ... }: with lib; {
  config = {
    deploy.targets.ostara = {
      nodeNames = singleton "ostara";
      tf = {
        resources.ostara = {
          provider = "null";
          type = "resource";
          connection = {
            port = 62954;
            host = "192.168.1.245";
          };
        };
      };
    };
    network.nodes.ostara = {
      imports = lib.hostImport "ostara";
      networking = {
        hostName = "ostara";
      };
    };
  };
}
