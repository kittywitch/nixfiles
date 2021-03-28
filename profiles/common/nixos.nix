{ config, lib, pkgs, sources, ... }:

{
  imports = [ ./nixos ];

  config = { home-manager.users.kat = { imports = [ ./home.nix ]; }; };
}
