{ lib, ... }:

{
  imports = [ ./home ];

  deploy.profile.kat = true;
}
