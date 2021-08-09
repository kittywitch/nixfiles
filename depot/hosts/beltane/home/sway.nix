{ config, pkgs, lib, ... }:

with lib;

{
  imports = [ ./swayidle.nix ];

  wayland.windowManager.sway = {
    config =
      let
        lockCommand = "swaylock -i VGA-1:${builtins.elemAt config.kw.wallpapers 0} -s fill";
        cfg = config.wayland.windowManager.sway.config;
      in
      {
        #startup = [{ command = "${pkgs.ckb-next}/bin/ckb-next -b"; }];

        output =
          let
            middle = {
              res = "1280x1024@75Hz";
              pos = "1920 0";
            };
          in
          {
            "VGA-1" = middle;
          };

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

        };
      };
}
