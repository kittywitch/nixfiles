{ lib, ... }:

{
  imports = [ ./nixos ];

  options = { deploy.profile.laptop = lib.mkEnableOption "lappytop" // { default = true; }; };

  config = { home-manager.users.kat = { imports = [ ./home.nix ]; }; };
}
