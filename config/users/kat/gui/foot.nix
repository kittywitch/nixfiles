{ config, lib, pkgs, ... }:

with lib;

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "foot";
        locked-title = false;
        font = "${config.kw.font.name}:size=${toString config.kw.font.size}, Twitter Color Emoji:size=8";
        font-bold = "${config.kw.font.name}:size=${toString config.kw.font.size}:style=Bold";
        font-italic = "${config.kw.font.name}:size=${toString config.kw.font.size}:style=Italic";
        font-bold-italic = "${config.kw.font.name}:size=${toString config.kw.font.size}:style=Bold Italic";
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
