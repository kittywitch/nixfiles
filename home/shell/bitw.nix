{ config, pkgs, meta, lib, ... }: {
  programs.rbw = {
    enable = true;
    package = lib.mkIf (meta.trusted ? secrets) (pkgs.writeShellScriptBin "bitw" ''${pkgs.rbw-bitw}/bin/bitw -p gpg://${config.kw.secrets.repo.bitw.source} "$@"'');
    settings = {
      email = "kat@kittywit.ch";
      base_url = "https://vault.kittywit.ch";
      identity_url = null;
      lock_timeout = 3600;
    };
  };
}
