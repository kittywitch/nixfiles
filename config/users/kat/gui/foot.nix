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
        font = "Iosevka Term:size=9, Twitter Color Emoji:size=8";
        font-bold = "Iosevka Term:size=9:style=Bold";
        font-italic = "Iosevka Term:size=9:style=Italic";
        font-bold-italic = "Iosevka Term:size=9:style=Bold Italic";
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
