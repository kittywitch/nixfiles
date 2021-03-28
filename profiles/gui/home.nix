{ lib, ... }:

{
  imports = [ ./home ];

  deploy.profile.gui = true;
}
