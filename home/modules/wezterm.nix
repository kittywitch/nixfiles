{ config, lib, pkgs, ... }: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
in {
  options.programs.wezterm = {
    enable = mkEnableOption "the wezterm terminal emulator";
  };
  config = mkIf config.programs.wezterm.enable {
    home.packages = [
      pkgs.wezterm
    ];
    xdg.configFile."wezterm/wezterm.lua".text = ''
      local = wezterm = require 'wezterm'
      return {
        check_for_updates = false,
        enable_tab_bar = true
      }
    '';
  };
}
