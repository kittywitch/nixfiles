{ config, pkgs, ... }: {
  home.packages = [
    pkgs.deadnix
  ];
}
