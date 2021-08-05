{ config, pkgs, lib, ... }:

with lib;

{
  programs.sway = {
    enable = any (user: user.wayland.windowManager.sway.enable) (attrValues config.home-manager.users);
    extraPackages = with pkgs; mkForce [ xwayland swaylock swayidle ];
  };
}
