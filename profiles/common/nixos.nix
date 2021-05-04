{ config, lib, pkgs, ... }:

{
  imports = [ ./nixos ../../users ];

  config = { home-manager.users.kat = { imports = [ ./home.nix ]; }; };
}
