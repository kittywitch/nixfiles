{ config, pkgs, lib, sources, ... }:

{
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; lib.mkForce [ xwayland swaylock swayidle ];
  };
}
