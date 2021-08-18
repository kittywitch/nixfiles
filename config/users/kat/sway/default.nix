{ config, pkgs, ... }:

{
  imports = [
    ./waybar.nix
    ./wofi.nix
    ./mako.nix
    ./sway.nix
    ./gammastep.nix
    ./konawall.nix
    ./packages.nix
  ];
}
