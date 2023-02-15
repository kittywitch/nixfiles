{ config, lib, pkgs, ... }: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) attrsOf unspecified;
  inherit (lib.generators) toKeyValue;
  cfg = config.programs.wofi;
in {
  options.programs.wofi = {
    enable = mkEnableOption "wofi, an unmaintained launcher program for wlroots";
    package = mkOption {
      type = unspecified;
      default = pkgs.wofi;
    };
    exec = mkOption {
      internal = true;
      type = unspecified;
      default = "${cfg.package}/bin/wofi";
    };
    settings = mkOption {
      type = attrsOf unspecified;
    };
  };
  config = mkMerge [
  {
    programs.wofi.settings.term = config.wayland.windowManager.sway.config.terminal;
  }
   (mkIf cfg.enable {
    xdg.configFile."wofi/config" = {
      text = toKeyValue {} cfg.settings;
    };
    wayland.windowManager.sway.config.menu = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --no-generic --dmenu=\"${cfg.exec}\" --term='${cfg.settings.term}'";
  })
  ];
}
