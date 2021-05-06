{ config, lib, pkgs, ... }:

{
  imports = [ ./nixos ];

  deploy.profile.gui = true;
}
