{ config, lib, ... }:

{
  secrets = {
    persistentRoot = lib.mkDefault "${config.xdg.cacheHome}/kat/secrets";
    external = true;
  };
}

