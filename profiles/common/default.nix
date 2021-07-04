{ config, users, lib, pkgs, ... }:

{
  imports = [
    users.kat.base
    users.kairi.base
    users.arc
    users.hexchen
    ./system.nix
    ./base16.nix
    ./net.nix
    ./access.nix
    ./locale.nix
    ./nix.nix
    ./ssh.nix
    ./packages.nix
    ./secrets.nix
  ];
}
