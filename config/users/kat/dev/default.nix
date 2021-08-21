{ config, lib, pkgs, ... }:

{
  imports = [
    ./rustfmt.nix
    ./packages.nix
    ./cookiecutter.nix
    ./emacs.nix
  ];
}
