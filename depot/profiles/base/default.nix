{ config, meta, lib, pkgs, ... }:

{
  imports = with meta; [
    users.kat.base
#    users.kairi.base TODO
    users.arc
    users.hexchen
    ./system.nix
    ./home.nix
    ./profiles.nix
    ./shell.nix
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
