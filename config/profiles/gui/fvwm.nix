{ config, lib, ... }:

with lib;

{
  config = mkIf (any (user: user.programs.fvwm.enable) (attrValues config.home-manager.users)) {
    services.xserver.enable = true;
    services.xserver.displayManager.startx.enable = true;
    services.xserver.windowManager.fvwm = {
      enable = true;
      gestures = true;
    };
  };
}
