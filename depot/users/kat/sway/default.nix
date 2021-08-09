{ config, pkgs, ... }:

{
  imports = [
    ./waybar
    ./mako.nix
    ./sway.nix
    ./gammastep.nix
    ./konawall.nix
    ./packages.nix
  ];
}
