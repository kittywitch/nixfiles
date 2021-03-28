{ lib, ... }:

{
  imports = [ ./nixos ];

  home-manager.users.kat = { imports = [ ./home.nix ]; };

  deploy.profile.sway = true;
}
