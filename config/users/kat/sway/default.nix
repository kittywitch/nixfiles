{ config, pkgs, ... }:

{
  deploy.profile.sway = true;

  imports = [
    ./waybar
    ./mako.nix
    ./sway.nix
    ./gammastep.nix
    ./konawall.nix
    ./packages.nix
  ];
}
