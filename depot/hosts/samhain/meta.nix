{ lib, config, root, profiles, ... }: with lib; {
  config = {
    deploy.targets.personal = {
      tf = {
        resources.samhain = {
          provider = "null";
          type = "resource";
          connection = {
            port = 62954;
            host = "192.168.1.135";
          };
        };
      };
    };
    network.nodes.samhain = {
      imports = lib.hostImport {
        hostName = "samhain";
        inherit profiles root;
      };
      networking = {
        hostName = "samhain";
      };
    };
  };
}
