{ config, pkgs, lib, ... }:

{
  kw.theme.enable = true;

  base16 = {
    shell.enable = true;
    schemes = [ "atelier.atelier-cave" "atelier.atelier-cave-light" ];
    alias.light = "atelier.atelier-cave-light";
    alias.dark = "atelier.atelier-cave";
  };
}
