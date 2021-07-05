{ config, pkgs, ... }:

{
  imports = [ ./sway.nix ];

  deploy.profile.sway = true;
}
