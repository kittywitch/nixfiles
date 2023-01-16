_: {
  programs.wezterm.enable = true;
  xdg.configFile."wezterm/wezterm.lua".text = ''
    local = wezterm = require 'wezterm'
    return {
      check_for_updates = false,
      enable_tab_bar = true
    }
  '';
}
