{ config, pkgs, lib, ... }:

with lib;

{
  wayland.windowManager.sway.config = {
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
    };
  }
