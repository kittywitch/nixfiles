{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ pinentry.gtk2 ];
}
