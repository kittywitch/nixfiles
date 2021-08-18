{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./swayidle.nix ];

  wayland.windowManager.sway.config =
    let
      lockCommand = "swaylock -i eDP-1:${builtins.elemAt config.kw.wallpapers 0} -s fill";
      cfg = config.wayland.windowManager.sway.config;
    in
    {
      output =
        let
          laptop = {
            res = "1920x1080";
            pos = "0 0";
          };
        in
        { "eDP-1" = laptop; };

      keybindings = {
        "${cfg.modifier}+x" = "exec ${lockCommand}";
      };

      modes = {
        "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown" =
          {
            "l" = "exec ${lockCommand}, mode default";
            "e" = "exec swaymsg exit, mode default";
            "s" = "exec systemctl suspend, mode default";
            "h" = "exec systemctl hibernate, mode default";
            "r" = "exec systemctl reboot, mode default";
            "Shift+s" = "exec systemctl shutdown, mode default";
            "Return" = "mode default";
            "Escape" = "mode default";
          };
      };

      input = {
        "1739:33362:Synaptics_TM3336-002" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
          click_method = "clickfinger";
        };
      };
    };
}
