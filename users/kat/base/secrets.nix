{ config, lib, ... }:

{
  secrets = {
    persistentRoot = config.xdg.cacheHome + "/kat/secrets";
    external = true;
  };
}

