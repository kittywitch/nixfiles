{ lib, ... }:

{
  imports = [ ./home ];

  #home-manager.useGlobalPkgs = true;
  #home-manager.users.kat = {
  #  imports = [ ../../../modules/home ];
  #};

  options = { deploy.profile.kat = lib.mkEnableOption "uhh meow"; };
}
