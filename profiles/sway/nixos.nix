{ lib, ... }:

{
  imports = [ ./nixos ];

  deploy.profile.sway = true;
}
