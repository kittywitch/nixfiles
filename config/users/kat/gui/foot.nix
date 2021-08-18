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
        font = "${config.kw.font.name}:size=${toString config.kw.font.size}, Twitter Color Emoji:size=8";
        font-bold = "${config.kw.font.name}:size=${toString config.kw.font.size}:style=Bold";
        font-italic = "${config.kw.font.name}:size=${toString config.kw.font.size}:style=Italic";
        font-bold-italic = "${config.kw.font.name}:size=${toString config.kw.font.size}:style=Bold Italic";
        dpi-aware = "no";
      };
      colors = {
        alpha = "0.9";
      };
      key-bindings = {
        show-urls-copy = "Control+Shift+i";
      };
    };
  };
}
