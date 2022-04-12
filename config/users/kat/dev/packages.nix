{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
    hyperfine
    hexyl
    tokei
    nixpkgs-fmt
    pandoc
    hugo
  ];
}
