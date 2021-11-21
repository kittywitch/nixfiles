{ config, meta, inputs, lib, pkgs, ... }:

{
 imports = lib.optional (meta.trusted ? secrets) meta.trusted.secrets;

  secrets = {
    root = "/var/lib/kat/secrets";
    persistentRoot = "/var/lib/kat/secrets";
    external = true;
  };
}
