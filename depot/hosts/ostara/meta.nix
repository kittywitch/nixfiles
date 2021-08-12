{ meta, profiles, config, lib, ... }: with lib; {
  config = {
    deploy.targets.ostara = {
      tf = {
        resources.ostara = {
          provider = "null";
          type = "resource";
          connection = {
            port = 62954;
            host = meta.network.nodes.ostara.network.addresses.private.ipv4.address;
          };
        };
      };
    };
    network.nodes.ostara = {
      imports = lib.hostImport {
        hostName = "ostara";
        inherit profiles;
      };
      networking = {
        hostName = "ostara";
      };
    };
  };
}
