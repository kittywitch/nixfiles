{ lib, config, ... }: with lib; {
  config = {
    deploy.targets.personal = {
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
      network.nodes.samhain = {
        imports = lib.hostImport "samhain";
        networking = {
          hostName = "samhain";
        };
      };
    };
  };
}
