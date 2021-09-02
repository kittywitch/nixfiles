{ config, lib, pkgs, ... }:

{
  imports = [
    ./vim
    ./rink.nix
    ./shell.nix
    ./rustfmt.nix
    ./packages.nix
    ./cookiecutter.nix
  ];
}
