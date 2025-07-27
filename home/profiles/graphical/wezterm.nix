{
  inputs,
  pkgs,
  ...
}: {
  programs.wezterm = {
    enable = false;
    package = inputs.wezterm.outputs.packages.${pkgs.system}.default;
    extraConfig = ''
      local wezterm = require 'wezterm';
      local config = {}
      config.front_end = "OpenGL"
      config.font = wezterm.font_with_fallback({
                "Monaspace Krypton",
                "JetBrains Mono",
                "Noto Color Emoji",
                "Symbols Nerd Font Mono",
      })
      config.window_padding = {
        left = 8,
        right = 8,
        top = 8,
        bottom = 8,
      }
      config.use_fancy_tab_bar = true
      config.tab_bar_at_bottom = true
      config.hide_mouse_cursor_when_typing = false
      config.window_decorations = "TITLE | RESIZE"
      config.warn_about_missing_glyphs = false
      config.font_size = 12.0
      config.check_for_updates = false
      return config
    '';
  };
}
