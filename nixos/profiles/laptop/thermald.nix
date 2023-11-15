{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.machine.cpuVendor == "intel") {
    services.thermald.enable = true;
  };
}
