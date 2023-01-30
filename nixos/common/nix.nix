{lib, ...}: let
  inherit (lib.modules) mkDefault;
in {
  boot.loader = {
    grub.configurationLimit = 8;
    systemd-boot.configurationLimit = 8;
  };

  nix = {
    settings = {
      trusted-users = [
        "deploy"
      ];
    };
    gc = {
      automatic = mkDefault false;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 7d";
    };
  };
}
