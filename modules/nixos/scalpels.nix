{lib, ...}: let
  inherit (lib.types) listOf path;
  inherit (lib.options) mkOption;
in {
  options.scalpels = mkOption {
    type = listOf path;
    default = [];
  };
}
