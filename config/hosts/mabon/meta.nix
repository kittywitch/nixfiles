{ lib, config, ... }: with lib; {
  deploy.targets.mabon = {
    nodeNames = lib.singleton "mabon";
    tf = {
      resources.mabon = {
        provider = "null";
        type = "resource";
        connection = {
          port = 62954;
          host = "192.168.1.119";
        };
      };
    };
  };
  network.nodes.mabon = {
    imports = lib.hostImport "mabon";
    networking = {
      hostName = "mabon";
    };
  };
}
