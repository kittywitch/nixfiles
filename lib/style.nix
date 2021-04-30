{ pkgs }:

rec {
  base16 = mapAttrs (_: toString) pkgs.base16.shell.shell256;

  font = {
    name = "FantasqueSansMono Nerd Font";
    size = "10";
    size_css = "14px";
  };
}
