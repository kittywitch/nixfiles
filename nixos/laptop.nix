{
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
in {
  powerManagement.cpuFreqGovernor = mkDefault "powersave";
  programs.light.enable = true;
}
