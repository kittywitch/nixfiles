{ config, pkgs, ... }:

{
  wayland.windowManager.sway.config = {
    output = let
      laptop = {
        res = "1920x1080";
        pos = "0 0";
        bg = "${../../../private/files/wallpapers/main.png} fill";
      };
    in { "eDP-1" = laptop; };

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
