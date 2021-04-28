{ config, pkgs, ... }:

{
  imports = [ ./waybar ./mako.nix ./sway.nix ./swayidle.nix ./gammastep.nix ];
}
