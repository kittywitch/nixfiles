{ config, lib, pkgs, ... }:

{
  imports = [ ./nixos ];

  options = { deploy.profile.gui = lib.mkEnableOption "graphical system"; };
}
