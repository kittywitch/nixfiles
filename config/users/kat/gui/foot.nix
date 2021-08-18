{ config, lib, pkgs, ... }:

with lib;

{
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
