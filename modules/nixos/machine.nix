{lib, ...}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum;
in {
  options.machine = {
    cpuVendor = mkOption {
      type = enum [
        "intel"
        "amd"
        "apple"
      ];
      description = "CPU vendor";
    };
  };
}
