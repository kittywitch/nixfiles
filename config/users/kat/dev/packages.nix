{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyperfine
    hexyl
    tokei
    nixpkgs-fmt
    pandoc
    apache-directory-studio
    hugo
  ];
}
