_: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm';
      return {
        font = wezterm.font "Monaspace Krypton",
        font_size = 10.0,
        check_for_updates = false,
        show_update_window = false,
        enable_tab_bar = true
      }
    '';
  };
}
