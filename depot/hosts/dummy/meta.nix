{ lib, config, depot, ... }: with lib; {
  deploy.targets.dummy.enable = false;
  network.nodes.dummy = {
    imports = lib.hostImport {
      hostName = "dummy";
      inherit (depot) profiles;
    };
    networking = {
      hostName = "dummy";
    };
  };
}
