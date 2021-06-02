{ config, lib, pkgs, ... }:

with lib;

let
  witch.style.base16 = lib.mapAttrs' (k: v: lib.nameValuePair k "#${v.hex.rgb}")
  config.lib.arc.base16.schemeForAlias.default;
  colors.ansi = builtins.concatStringsSep ", " (map (c: ''"#${c.hex.rgb}"'') (sublist 0 8 config.lib.arc.base16.schemeForAlias.default.shell.colours));
  colors.brights = builtins.concatStringsSep ", " (map (c: ''"#${c.hex.rgb}"'') (sublist 8 8 config.lib.arc.base16.schemeForAlias.default.shell.colours));
in {
  home.packages = [
    pkgs.wezterm
  ];

  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm';

    return {
      term = "wezterm",
      font = wezterm.font_with_fallback({"FantasqueSansMono Nerd Font","Twitter Color Emoji"}),
      font_size = 10.0,
      window_background_opacity = 0.9,
      hide_tab_bar_if_only_one_tab = true,
      colors = {
        ansi = {${colors.ansi}},
        brights = {${colors.brights}},
        background = "${witch.style.base16.base00}",
        foreground = "${witch.style.base16.base05}",
        tab_bar = {
          background = "${witch.style.base16.base00}",
          active_tab = {
            bg_color = "${witch.style.base16.base0A}",
            fg_color = "${witch.style.base16.base05}",
          },
          inactive_tab = {
            bg_color = "${witch.style.base16.base01}",
            fg_color = "${witch.style.base16.base03}",
          },
        },
      },
    }
  '';
}
