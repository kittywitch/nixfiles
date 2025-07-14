{
  config,
  options,
  lib,
  ...
}: let
  inherit (lib.types) attrsOf submodule;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkDefault;
  inherit (lib.attrsets) genAttrs;
  fileOption = mkOption {
      type = attrsOf (submodule (
        _: {
          config.force = mkDefault config.home.clobberAllFiles;
        }
      ));
    };

in {
  options = {
    home = {
      clobberAllFiles = mkEnableOption "clobbering all files";
      file = fileOption;
    };
    xdg = genAttrs [ "configFile" "cacheFile" "stateFile" "dataFile" ] (_: fileOption);
  };
}
