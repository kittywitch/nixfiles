{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  documentation.nixos.enable = mkForce false;
}
