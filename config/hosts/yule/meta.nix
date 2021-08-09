{ lib, config, depot, ... }: with lib; {
  config = {
    deploy.targets.personal = {
      tf = {
        resources.yule = {
          provider = "null";
          type = "resource";
          connection = {
            port = 62954;
            host = "192.168.1.92";
          };
        };
      };
    };
    network.nodes.yule = {
      imports = lib.hostImport {
        hostName = "yule";
        inherit (depot) profiles;
      };
      networking = {
        hostName = "yule";
      };
    };
  };
}
