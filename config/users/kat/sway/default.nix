{ config, pkgs, ... }:

{
  imports = [
    ./xkb.nix
    ./waybar.nix
    ./wofi.nix
    ./mako.nix
    ./sway.nix
    ./gammastep.nix
    ./konawall.nix
    ./packages.nix
  ];
}
