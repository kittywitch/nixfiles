{ config, lib, pkgs, ... }:

{
  imports = [ ./nixos ];

  home-manager.users.kat = { imports = [ ./home.nix ]; };
}
