{ meta, profiles, config, root, lib, ... }: with lib; {
  config = {
    deploy.targets.personal = {
      tf = {
        resources.yule = {
          provider = "null";
          type = "resource";
          connection = {
            port = 62954;
            host = meta.network.nodes.yule.network.addresses.private.ipv4.address;
          };
        };
      };
    };
    network.nodes.yule = {
      imports = lib.hostImport {
        hostName = "yule";
        inherit profiles root;
      };
      networking = {
        hostName = "yule";
      };
    };
  };
}
