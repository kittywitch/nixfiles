{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    borgbackup
    homebank
  ];
}
