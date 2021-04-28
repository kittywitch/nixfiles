{ config, pkgs, lib, ... }:

{
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; lib.mkForce [ xwayland swaylock swayidle ];
  };
}
