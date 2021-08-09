{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    xdg-utils
  ];
}
