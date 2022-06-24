{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
    apache-directory-studio
    hyperfine
    hexyl
    tokei
    nixpkgs-fmt
    pandoc
    hugo
  ];
}
