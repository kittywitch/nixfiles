{lib, ...}: let
  inherit (lib.modules) mkDefault;
in {
  nix.gc = {
    automatic = mkDefault true;
    dates = mkDefault "weekly";
    options = mkDefault "--delete-older-than 7d";
  };
}
