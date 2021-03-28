{ config, lib, pkgs, ... }:

{
  imports = [ ./nixos ];

  options = { deploy.profile.gui = lib.mkEnableOption "graphical system" // { default = true; }; };

  config = { home-manager.users.kat = { imports = [ ./home.nix ]; }; };
}
