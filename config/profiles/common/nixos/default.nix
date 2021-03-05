{ config, lib, pkgs, sources, ... }:

{
  imports = [
    ./system.nix
    ./net.nix
    ./access.nix
    ./locale.nix
    ./nix.nix
    ./ssh.nix
    ./packages.nix
    ./secrets.nix
  ];
}
