{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.kitty.terminfo ];
}