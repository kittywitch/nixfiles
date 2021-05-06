{ config, pkgs, ... }:

{
  home.sessionVariables.TERMINFO_DIRS =
    "${pkgs.kitty.terminfo.outPath}/share/terminfo";
}
