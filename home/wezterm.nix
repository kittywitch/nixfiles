{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		wezterm
	];

	xdg.configFile."wezterm/wezterm.lua".text = ''
		local wezterm = require 'wezterm'
		return {
      check_for_updates = true,
			enable_tab_bar = true,
			font = wezterm.font "${config.kw.theme.font.termName}",
			font_size = ${toString config.kw.theme.font.size},
		}
	'';
}
