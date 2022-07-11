{ config, pkgs, lib, root, ... }: {
  runners = {
    lazy = {
      file = ./default.nix;
      args = [ "--show-trace" ];
    };
  };

  kw.secrets.command =
    let
      bitw = pkgs.writeShellScriptBin "bitw" ''${pkgs.rbw-bitw}/bin/bitw -p gpg://${config.network.nodes.${pkgs.hostPlatform.parsed.kernel.name}.${builtins.getEnv "HOME_HOSTNAME"}.kw.secrets.repo.bitw.source} "$@"'';
    in
    "${bitw}/bin/bitw get";

  deploy.targets.dummy.enable = false;
  _module.args.pkgs = lib.mkDefault pkgs;
}
