{ config, pkgs, ... }:

{
  imports = [
    ./xkb.nix
    ./waybar
    ./wofi
    ./mako.nix
    ./sway.nix
    ./gammastep.nix
    ./konawall.nix
    ./packages.nix
  ];
}
