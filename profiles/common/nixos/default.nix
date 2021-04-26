{ config, lib, pkgs, sources, ... }:

{
  imports = [
    ./system.nix
    ./access.nix
    ./locale.nix
    ./nix.nix
    ./ssh.nix
    ./packages.nix
    ./secrets.nix
  ];
}
