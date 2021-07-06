{ lib, config, ... }: with lib; {
  network.nodes.dummy = {
    imports = lib.hostImport "dummy";
    networking = {
      hostName = "dummy";
    };
  };
}
