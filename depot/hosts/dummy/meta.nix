{ lib, config, root,  profiles, ... }: with lib; {
  deploy.targets.dummy.enable = false;
  network.nodes.dummy = {
    imports = lib.hostImport {
      hostName = "dummy";
      inherit profiles root;
    };
    networking = {
      hostName = "dummy";
    };
  };
}
