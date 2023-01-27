{lib, ...}: let
  inherit (lib.modules) mkDefault;
in {
  boot.loader = {
    grub.configurationLimit = 8;
    systemd-boot.configurationLimit = 8;
  };

  nix.gc = {
    automatic = mkDefault true;
    dates = mkDefault "weekly";
    options = mkDefault "--delete-older-than 7d";
  };
}
