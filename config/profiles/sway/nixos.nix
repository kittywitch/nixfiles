{ lib, ... }:

{
  imports = [ ./nixos ];

  options = { deploy.profile.sway = lib.mkEnableOption "sway wm"; };
}
