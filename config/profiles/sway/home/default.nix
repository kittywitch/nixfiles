{ config, pkgs, sources, ... }:

{
  imports = [ ./waybar ./mako.nix ./sway.nix ];
}
