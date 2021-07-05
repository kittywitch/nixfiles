{ config, pkgs, ... }:

{
  imports = [ ./fvwm.nix ];

  deploy.profile.fvwm = true;
}
