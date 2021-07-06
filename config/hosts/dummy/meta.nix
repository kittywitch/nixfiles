{ lib, config, ... }: with lib; {
  network.nodes.mabon = {
    imports = lib.hostImport "mabon";
    networking = {
      hostName = "mabon";
    };
  };
}
