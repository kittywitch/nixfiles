{ inputs, pkgs, ... }: {
  programs.wezterm = {
    enable = true;
    #package = inputs.wezterm.outputs.packages.${pkgs.system}.default;
    extraConfig = ''
            local wezterm = require 'wezterm';
            return {
            front_end=‘WebGpu’,
              font = wezterm.font_with_fallback({
        -- /nix/store/rh47mw5pfp7w2nmkn8rlwjkmkzf11prq-monaspace-1.000/share/fonts/opentype/MonaspaceKrypton-Regular.otf, FontConfig
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
              font_size = 10.0,
              check_for_updates = false,
              show_update_window = false,
              enable_tab_bar = false
            }
    '';
  };
}
