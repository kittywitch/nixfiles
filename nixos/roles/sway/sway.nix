{ config, pkgs, std, lib, ... }: let
  inherit (std) set list;
  inherit (lib.modules) mkForce;
in {
  programs.sway = {
    enable = list.any (user: user.wayland.windowManager.sway.enable) (set.values config.home-manager.users);
    extraPackages = with pkgs; mkForce [ xwayland swaylock swayidle swaylock-fancy wmctrl ];
  };
}
