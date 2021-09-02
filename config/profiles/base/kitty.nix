{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.buildPackages.buildPackages.kitty.terminfo ];
}
