{
  config,
  lib,
  pkgs,
  ...
}: let
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
  };
}
