{ lib, ... }:

{
  imports = [ ./nixos ];

  options = { deploy.profile.laptop = lib.mkEnableOption "lappytop"; };
}
