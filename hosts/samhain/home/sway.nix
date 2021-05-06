{ config, pkgs, ... }:

{
  wayland.windowManager.sway = {
    config = {
      startup = [{ command = "${pkgs.ckb-next}/bin/ckb-next -b"; }];

      output = let
        left = {
          res = "1920x1080";
          pos = "0 0";
        };
        middle = {
          res = "1920x1200";
          pos = "1920 0";
        };
        right = {
          res = "1920x1080";
          pos = "3840 0";
        };
      in {
        "DP-1" = left;
        "DVI-D-1" = middle;
        "HDMI-A-1" = right;
      };

      input = {
        "5824:1503:screenstub-tablet" = { events = "disabled"; };
        "5824:1503:screenstub-mouse" = { events = "disabled"; };
        "5824:1503:screenstub-kbd" = { events = "disabled"; };
        "1386:215:Wacom_BambooPT_2FG_Small_Pen" = {
          map_to_output = "HDMI-A-1";
        };
        "1386:215:Wacom_BambooPT_2FG_Small_Finger" = {
          natural_scroll = "enabled";
          middle_emulation = "enabled";
          tap = "enabled";
          dwt = "enabled";
          accel_profile = "flat";
          pointer_accel = "0.05";
        };
      };
    };
    extraConfig = ''
      workspace "1" output "DP-1"
      workspace "11:F1" output "DVI-1"
      workspace "12:F2" output "HDMI-A-1"
    '';
  };
}
