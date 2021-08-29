{ config, meta, lib, pkgs, ... }:

{
  imports = with meta; [
    users.kat.base
    users.arc
    users.hexchen
    ./system.nix
    ./kitty.nix
    ./home.nix
    ./profiles.nix
    ./shell.nix
    ./base16.nix
    ./network.nix
    ./access.nix
    ./locale.nix
    ./nix.nix
    ./ssh.nix
    ./packages.nix
    ./secrets.nix
  ];
}
