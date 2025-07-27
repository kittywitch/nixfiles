{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;
in {
    programs.zsh.shellAliases = {
      uwufetch = "${getExe pkgs.fastfetch} --chafa ${./nixowos.png} --logo-height 32";
    };
}
