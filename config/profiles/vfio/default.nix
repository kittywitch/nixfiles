{ config, pkgs, ... }:

{
  deploy.profile.vfio = true;

  environment.systemPackages = with pkgs; [
    screenstub
  ];
}
