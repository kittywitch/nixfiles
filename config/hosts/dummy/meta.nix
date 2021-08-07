{ lib, config, ... }: with lib; {
  deploy.targets.dummy.enable = false;
  network.nodes.dummy = {
    imports = lib.hostImport "dummy";
    networking = {
      hostName = "dummy";
    };
  };
}
