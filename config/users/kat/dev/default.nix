{ config, lib, pkgs, ... }:

{
  imports = [
    ./vim
    ./zsh.nix
    ./rustfmt.nix
    ./packages.nix
    ./cookiecutter.nix
  ];
}
