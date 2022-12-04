{ config, lib, ... }: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.role.personal {
    services.fstrim.enable = true;
  };
}
