{ lib, config, depot, ... }: with lib; {
  config = {
    deploy.targets.ostara = {
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
      imports = lib.hostImport {
        hostName = "ostara";
        inherit (depot) profiles;
      };
      networking = {
        hostName = "ostara";
      };
    };
  };
}
