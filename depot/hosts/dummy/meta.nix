{ config, lib, kw, ... }: with lib; {
  deploy.targets.dummy.enable = false;
  network.nodes.dummy = {
    imports = kw.nodeImport "dummy";
  };
}
