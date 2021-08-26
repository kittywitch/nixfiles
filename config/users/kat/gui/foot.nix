{ config, lib, pkgs, ... }:

with lib;

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "foot";
        locked-title = false;
        font = "${config.kw.theme.font.name}:size=${toString config.kw.theme.font.size}, Twitter Color Emoji:size=8";
        font-bold = "${config.kw.theme.font.name}:size=${toString config.kw.theme.font.size}:style=Bold";
        font-italic = "${config.kw.theme.font.name}:size=${toString config.kw.theme.font.size}:style=Italic";
        font-bold-italic = "${config.kw.theme.font.name}:size=${toString config.kw.theme.font.size}:style=Bold Italic";
        dpi-aware = "no";
      };
      cursor = {
        style = "beam";
      };
      bell = {
        urgent = true;
        notify = true;
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
