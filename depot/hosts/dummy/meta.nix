{ lib, config, profiles, ... }: with lib; {
  deploy.targets.dummy.enable = false;
  network.nodes.dummy = {
    imports = lib.hostImport {
      hostName = "dummy";
      inherit profiles;
    };
    networking = {
      hostName = "dummy";
    };
  };
}
