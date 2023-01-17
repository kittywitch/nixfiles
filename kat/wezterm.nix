_: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local = wezterm = require 'wezterm'
      return {
        check_for_updates = false,
        enable_tab_bar = true
      }
    '';
  };
}
