{ lib, ... }:

{
  imports = [ ./home ];

  deploy.profile.sway = true;
}
