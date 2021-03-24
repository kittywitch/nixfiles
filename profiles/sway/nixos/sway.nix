{ config, pkgs, lib, sources, ... }:

{
  config = lib.mkIf config.deploy.profile.sway {
    programs.sway = {
      enable = true;
      extraPackages = with pkgs; lib.mkForce [ xwayland swaylock swayidle ];
    };
  };
}
