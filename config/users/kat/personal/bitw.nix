{ config, pkgs, lib, ... }: {
  programs.rbw = {
    enable = true;
    package = pkgs.writeShellScriptBin "bitw" ''${pkgs.rbw-bitw}/bin/bitw -p gpg://${config.kw.repoSecrets.bitw.source} "$@"'';
    settings = {
      email = "kat@kittywit.ch";
      base_url = "https://vault.kittywit.ch";
      identity_url = null;
      lock_timeout = 3600;
    };
  };
}
