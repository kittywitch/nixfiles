{ config, lib, pkgs, ... }:

with lib;

let
  witch.style.base16 = lib.mapAttrs' (k: v: lib.nameValuePair k "#${v.hex.rgb}")
  config.lib.arc.base16.schemeForAlias.default;
  colors.ansi = builtins.concatStringsSep ", " (map (c: ''"#${c.hex.rgb}"'') (sublist 0 8 config.lib.arc.base16.schemeForAlias.default.shell.colours));
  colors.brights = builtins.concatStringsSep ", " (map (c: ''"#${c.hex.rgb}"'') (sublist 8 8 config.lib.arc.base16.schemeForAlias.default.shell.colours));
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "FantasqueSansMono Nerd Font:size=10";
        dpi-aware = "yes";
      };
    };
  };
}
