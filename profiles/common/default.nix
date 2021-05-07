{ config, users, lib, pkgs, ... }:

{
  imports = [
    users.kat.base
    users.arc
    users.hexchen
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
