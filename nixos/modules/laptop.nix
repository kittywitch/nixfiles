{ config, lib, ... }: let
  inherit (lib.modules) mkIf mkDefault;
in {
  config = mkIf config.role.laptop {
    powerManagement.cpuFreqGovernor = mkDefault "powersave";
    programs.light.enable = true;
  };
}
