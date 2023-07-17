{
  config,
  pkgs,
  tree,
  std,
  lib,
  ...
}: let
  inherit (std) set list;
  inherit (lib.modules) mkForce;
in {
  imports = with tree.nixos.roles; [
    graphical
  ];
  programs.sway = {
    enable = list.any (user: user.wayland.windowManager.sway.enable) (set.values config.home-manager.users);
    extraPackages = with pkgs; mkForce [xwayland swaylock swayidle swaylock-fancy wmctrl];
  };
}
