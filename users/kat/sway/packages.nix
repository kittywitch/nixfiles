{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ kat-scrot ];
}
