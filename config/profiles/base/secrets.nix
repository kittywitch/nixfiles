{ config, meta, lib, pkgs, ... }:

{
  imports = lib.optional (meta.trusted ? secrets) meta.trusted.secrets;

  secrets = {
    root = "/var/lib/kat/secrets";
    persistentRoot = "/var/lib/kat/secrets";
    external = true;
  };

  kw.secrets.command =
    let
      bitw = pkgs.writeShellScriptBin "bitw" ''${pkgs.rbw-bitw}/bin/bitw -p gpg://${config.kw.secrets.repo.bitw.source} "$@"'';
    in
    "${bitw}/bin/bitw get";
}
