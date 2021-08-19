{ config, lib, ... }:

{
  base16 = {
    shell.enable = true;
    schemes = [ "atelier.atelier-cave" "atelier.atelier-cave-light" ];
    alias.light = "atelier.atelier-cave-light";
    alias.dark = "atelier.atelier-cave";
  };


  kw.hexColors = lib.mapAttrs' (k: v: lib.nameValuePair k "#${v.hex.rgb}")
    (lib.filterAttrs (n: _: lib.hasInfix "base" n) config.lib.arc.base16.schemeForAlias.default);
}
