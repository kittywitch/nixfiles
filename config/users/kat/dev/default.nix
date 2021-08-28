{ config, lib, pkgs, ... }:

{
  imports = [
    ./vim
    ./rustfmt.nix
    ./packages.nix
    ./cookiecutter.nix
  ];
}
