{ config, pkgs, lib, ... }: with lib; {
  options.kw.secrets.command = mkOption {
    type = types.str;
    default = let
      bitw = pkgs.writeShellScriptBin "bitw" ''${pkgs.rbw-bitw}/bin/bitw -p gpg://${config.network.nodes.all.${builtins.getEnv "HOME_HOSTNAME"}.kw.secrets.repo.bitw.source} "$@"'';
    in
    "${bitw}/bin/bitw get";
  };
}
