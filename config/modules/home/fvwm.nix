{ config, lib, ... }:

with lib;

{
  options.programs.fvwm = {
    enable = mkEnableOption "Enable FVWM";
  };
}
