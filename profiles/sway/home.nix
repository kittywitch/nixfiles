{ lib, ... }:

{
  imports = [ ./home ];

  options = { deploy.profile.sway = lib.mkEnableOption "sway wm"; };
}
