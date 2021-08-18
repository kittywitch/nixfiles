{ config, lib, pkgs, ... }:

with lib;

{
  wayland.windowManager.sway.config = {
    output = let
      laptop = {
        res = "1920x1080";
        pos = "0 0";
      };
    in
    { "eDP-1" = laptop; };

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
