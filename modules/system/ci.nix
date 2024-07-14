{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
in {
  options.ci = with lib.types; {
    enable =
      mkEnableOption "build via CI"
      // {
        default = config.system == "x86_64-linux";
      };
    allowFailure = mkOption {
      type = bool;
      default = false;
    };
  };
}
