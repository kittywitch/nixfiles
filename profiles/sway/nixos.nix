{ lib, ... }:

{
  imports = [ ./nixos ];

  options = { deploy.profile.sway = lib.mkEnableOption "sway wm" // { default = true; }; };

  config = { home-manager.users.kat = { imports = [ ./home.nix ]; }; };
}
