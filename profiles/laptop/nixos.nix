{ lib, ... }:

{
  imports = [ ./nixos ];

  deploy.profile.laptop = true;
}
