{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ sway-scrot ];
}
