{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		wezterm
	];

	xdg.configFile."wezterm/wezterm.lua".text = ''
		local wezterm = require 'wezterm'
		return {
			enable_tab_bar = true,
			font = wezterm.font "${config.kw.theme.font.termName}",
			font_size = ${toString config.kw.theme.font.size},
		}
	'';
}
