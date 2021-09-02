{ config, lib, pkgs, ... }:

{
  imports = [
    ./vim
    ./rink.nix
    ./zsh.nix
    ./rustfmt.nix
    ./packages.nix
    ./cookiecutter.nix
  ];
}
