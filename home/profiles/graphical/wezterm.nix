{
  inputs,
  pkgs,
  ...
}: {
  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.outputs.packages.${pkgs.system}.default;
    extraConfig = ''
            local wezterm = require 'wezterm';
            return {
              font = wezterm.font_with_fallback({
        "Monaspace Krypton",
        -- <built-in>, BuiltIn
        "JetBrains Mono",

        -- /nix/store/mc76mhlam0rggcgx3z695025phl07pi1-noto-fonts-color-emoji-2.042/share/fonts/noto/NotoColorEmoji.ttf, FontConfig
        -- Assumed to have Emoji Presentation
        -- Pixel sizes: [128]
        "Noto Color Emoji",

        -- <built-in>, BuiltIn
        "Symbols Nerd Font Mono",

      }),
      window_decorations = "TITLE | RESIZE",
      enable_wayland = true,
      warn_about_missing_glyphs = false,
              font_size = 12.0,
              check_for_updates = false,
              enable_tab_bar = false
            }
    '';
  };
}
