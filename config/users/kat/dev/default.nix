{ config, lib, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./cookiecutter.nix
    ./emacs.nix
  ];
}
