{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.fvwm = {
    enable = true;
    gestures = true;
  };
}
