{ config, lib, kw, ... }: {
  network.nodes.rinnosuke = {
    imports = kw.nodeImport "rinnosuke";
  };
}

